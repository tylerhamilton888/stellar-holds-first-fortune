"""Selection must save work without silently dropping changed/unknown coverage."""
import contextlib
import io
import json
import subprocess
import tempfile
import unittest
from collections import Counter
from pathlib import Path
from unittest.mock import patch

import check
import plan_validation as planner


class ValidationPlanTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads((planner.ROOT / 'tests/suites.json').read_text())

    def select(self, *paths, **kwargs):
        return planner.plan(paths, self.manifest, **kwargs)

    def test_docs_and_export_registration_do_not_start_game(self):
        for paths in [('docs/CHANGELOG.md',), ('tools/check_pack.py',),
                      ('.github/workflows/windows-release.yml',)]:
            self.assertFalse(self.select(*paths)['run_gameplay'])

    def test_ledger_includes_later_campaign_and_real_save_smoke(self):
        p = self.select('scripts/ledger137.gd')
        self.assertEqual(p['mode'], 'focused')
        self.assertTrue({'ledger137', 'restoration139', 'campaign138', 'invasion131',
                         'troll133', 'firstvisit99', 'loading'} <= set(p['cases']))
        self.assertLess(len(p['cases']), len(planner.full_cases(self.manifest)))

    def test_agent_guidance_is_docs_but_cannot_hide_runtime_changes(self):
        self.assertFalse(self.select('AGENTS.md')['run_gameplay'])
        self.assertEqual(self.select('AGENTS.md', 'scripts/unknown.gd')['mode'], 'full')

    def test_changed_character_case_does_not_run_every_character(self):
        p = self.select('tests/story_world117.gd')
        self.assertEqual(set(p['cases']), {'story_world117', *planner.SMOKE})

    def test_shared_unknown_and_deleted_runtime_files_are_full(self):
        for path in ['main.gd', 'main.tscn', 'scripts/state.gd', 'scripts/new_feature.gd',
                     'tests/support/game_fixture.gd', 'tests/suites.json',
                     'assets/story105/world/torvik.webp', 'project.godot', 'export_presets.cfg']:
            p = self.select(path)
            self.assertEqual(p['mode'], 'full', path)
            self.assertTrue(set(planner.full_cases(self.manifest)) <= set(p['cases']))

    def test_mixed_change_cannot_mask_unmapped_runtime(self):
        self.assertEqual(self.select('tools/check_pack.py', 'scripts/unknown.gd')['mode'], 'full')

    def test_full_override_retains_all_source_cases_and_people_once(self):
        p = self.select('docs/CHANGELOG.md', force_full=True)
        counts = Counter(x for shard in p['matrix']['include'] for x in shard['cases'])
        self.assertEqual(set(counts), set(planner.full_cases(self.manifest)))
        self.assertTrue(all(n == 1 for n in counts.values()))
        self.assertEqual(counts['people'], 1)

    def test_every_plan_shards_selected_cases_once(self):
        for paths in [('tools/check_pack.py',), ('scripts/ledger137.gd',), ('main.gd',),
                      ('tests/story_world117.gd', 'tests/story_world118.gd')]:
            p = self.select(*paths)
            flattened = [c for row in p['matrix']['include'] for c in row['cases']]
            self.assertEqual(sorted(flattened), p['cases'])
            self.assertEqual(len(flattened), len(set(flattened)))

    def test_mapping_targets_exist_and_suites_are_valid(self):
        for suite, paths in planner.DOMAINS.items():
            self.assertIn(suite, self.manifest['suites'])
            self.assertTrue(set(self.manifest['suites'][suite]) <= self.manifest['cases'].keys())
            for path in paths:
                self.assertTrue((planner.ROOT / path).is_file(), path)

    def test_bad_diff_falls_back_to_full(self):
        with patch('sys.argv', ['plan_validation.py', '--base', 'bad']), \
             patch.object(planner, 'changed_paths', side_effect=subprocess.CalledProcessError(1, 'git')), \
             contextlib.redirect_stdout(io.StringIO()) as output:
            planner.main()
        self.assertEqual(json.loads(output.getvalue())['mode'], 'full')

    def test_native_runner_deduplicates_and_preserves_failure_detection(self):
        for code, log, passed in [(0, 'LOADING63: 1 passed / 0 failed', True),
                                  (1, 'LOADING63: 1 passed / 0 failed', False),
                                  (0, 'no completion marker', False),
                                  (0, 'LOADING63: 1 passed / 0 failed\nSCRIPT ERROR: bad', False)]:
            with tempfile.TemporaryDirectory() as tmp, contextlib.redirect_stdout(io.StringIO()), \
                 patch.object(check.subprocess, 'run', return_value=subprocess.CompletedProcess([], code, log)) as run:
                self.assertEqual(check.run('/fake', 'core', Path(tmp)/'result', True,
                                           selected=['loading', 'loading']), passed)
                self.assertEqual(run.call_count, 1)

    def test_native_runner_rejects_empty_or_unknown_plan(self):
        for names in ([], ['missing']):
            with tempfile.TemporaryDirectory() as tmp, self.assertRaises(ValueError):
                check.run('/fake', 'core', Path(tmp)/'result', True, selected=names)


if __name__ == '__main__':
    unittest.main()
