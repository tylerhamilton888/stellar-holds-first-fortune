"""Bound human-facing summaries; full reports and diagnostic logs stay in files."""
import re
import sys
import weakref

MAX_OUTPUT_BYTES = 8000
MAX_MESSAGE_BYTES = 2048
_budgets = weakref.WeakKeyDictionary()
_long_token = re.compile(r'\S{160,}')


def excerpt(value, limit=240):
    text = str(value)[:max(limit * 4, 2048)]
    text = re.sub(r'data:[^\s]+', '[data URL omitted]', text)
    text = _long_token.sub('[long token omitted]', text)
    text = ''.join(c for c in text if c.isprintable() or c in '\n\t')
    raw = text.encode('utf-8')
    return raw[:limit].decode('utf-8', errors='ignore')


def emit(*values, sep=' ', end='\n', flush=False):
    stream = sys.stdout
    used = _budgets.get(stream, 0)
    if used >= MAX_OUTPUT_BYTES:
        return
    # A fixed message and process budget also bounds long Unicode lines and loops.
    message = excerpt(sep.join(str(v) for v in values), MAX_MESSAGE_BYTES - 1) + end
    raw = message.encode('utf-8')[:min(MAX_MESSAGE_BYTES, MAX_OUTPUT_BYTES - used)]
    text = raw.decode('utf-8', errors='ignore')
    stream.write(text)
    _budgets[stream] = used + len(text.encode('utf-8'))
    if flush:
        stream.flush()


def error_summary(log):
    count = 0
    samples = []
    for line in log.splitlines():
        if ('SCRIPT ERROR:' in line or line.startswith('ERROR:')) and not re.search(
                r'ERROR: \d+ resources still in use at exit', line):
            count += 1
            sample = excerpt(line)
            if len(samples) < 5 and sample not in samples:
                samples.append(sample)
    return samples, count
