import sys
import time
import logging
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

def progress(count, total, status=''):
    bar_len = 60
    filled_len = int(round(bar_len * count / float(total)))

    percents = round(100.0 * count / float(total), 1)
    bar = '=' * filled_len + '-' * (bar_len - filled_len)

    sys.stdout.write('[%s] %s%s ...%s\r' % (bar, percents, '%', status))
    sys.stdout.flush()

def on_modified(event):
    n = 0
    with open(sys.argv[1], "r") as f:
        n = len(f.readlines())
        progress((n - 3) if n > 3 else 0, 100 * 200, sys.argv[1])

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else '.'
    event_handler = FileSystemEventHandler()

    # Add event
    event_handler.on_modified = on_modified

    observer = Observer()
    observer.schedule(event_handler, path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    finally:
        observer.stop()
        observer.join()
