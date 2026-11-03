# Current courtship entry — Hearthknot

There are eight authored candidates. New courtship requires a crafted Hearthknot (1 timber and 1 copper ingot at an existing forge), a completed personal story, at least 5 friendship, an eligible available partner, and an explicit local offer. The accepted offer consumes one token from the pack. Ordinary gifts cannot spend it; exchanges do not sell it. Three shared moments and the existing betrothal requirements follow unchanged. Existing commitments are preserved without retroactive token payment. Renewed courtship after a breakup needs a new token.

The Hearthknot is an invitation, not a marriage ring. Friendship, personal errands and Alden/Maren's early-interest option remain available without it. Their independent relationship never consumes player possessions. Wedding and shared household gameplay remain milestone 06. Romance scenes currently use authored dialogue choices; moving-actor presentation remains future polish under STORY_SCENES.md.

Alden and Maren now begin courting when the player successfully begins courting another candidate, even before their introductions. Player betrothal to another candidate advances their betrothal. Elapsed days, friendship and rejected invitations never trigger either step. Choosing either Alden or Maren keeps their player romance available. Early interest is released by choosing somebody else; a later player breakup does not dissolve the NPC couple. Existing NPC commitments and historical hints are preserved; unfinished countdowns never expire. Existing player commitments elsewhere reconcile on load without spending items or inventing introductions.

---

# Six lives at the claim

Status: implemented; focused native acceptance passed.

## Deliverable

Six adults (three women, three men), authored appearances and personalities, individual gifts and personal errands, reciprocal courtship and persistent relationship stages. Preserve existing friendships and married couples.

## Read before editing

scripts/road_characters.gd; scripts/roads.gd; scripts/people.gd; scripts/conversation.gd; scripts/player_book.gd

Also read ../CURRENT_STATUS.md, CHECKPOINT.md, OWNER_DIRECTIVE.md sections relevant to this milestone, and ../DEVELOPMENT.md. Code and fresh test evidence override historical completion claims.

## Acceptance

Test all six locally, remote-action rejection, meaningful personal errands, calendar-day limits, mutual choice, save/reload and old saves. Inspect dialogue and world identities.

## Guardrail

Bespoke story-character art and expression production must follow docs/ROMANCE_CAST.md; shared families are a baseline, not final artwork.

## Checkpoint record

Record implementation commits, state keys/migrations, tests actually run, reviewed captures, incomplete items and exact next action here before moving on.

Implemented in scripts/courtship101.gd and existing conversation/People integration. Six candidates, six real material errands with choices/keepsakes, eighteen distinct date scenes, explicit courtship, betrothal and confirmed breakup. surface.courtship101 stores per-person quest, approach, stage, dates/day limits and keepsake; nested date integers normalize after JSON reload. Existing saved appearance identities remain authoritative.

Native cast101: import passed; courtship 299, people 432, roads 82 assertions, all passed (813 total). Reviewed final dialogue captures. Corrected Hakon’s route to keep it clear of the river. Bespoke final character frames/expressions and marriage are milestone six, not completed by shared-family defaults.
