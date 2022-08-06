import os
import functools
import threading
import unittest
import subprocess
from traceback import format_exc
from queue import Queue

TEST_DIR = os.path.dirname(__file__)
SOURCE_DIR = os.path.dirname(TEST_DIR)

def do_stuff(q1, a, k, method):
    try:
        q1.put(method(*a, **k))
    except Exception as e:
        q1.put(e)

def timeout(sec):
    def timeout_dec(func):
        @functools.wraps(func)
        def test(*args, **kwargs):
            q = Queue()
            p = threading.Thread(target=do_stuff, args=[q, args, kwargs, func], kwargs={}, daemon=True)
            p.start()
            p.join(sec)

            if p.is_alive():
                # I can't kill the thread, but just keep the tests running.
                raise TimeoutError(f"Timed out after {sec} seconds")
            else:
                x = q.get()
                if isinstance(x, Exception):
                    raise x
                return x
        return test
    return timeout_dec

class BaseTest(unittest.TestCase):

    MARS_filepath = os.path.join(TEST_DIR, "Mars4_5.jar")

    def _callTestMethod(self, method):
        try:
            method()
        except AssertionError as e:
            raise e
        except Exception as e:
            print(format_exc())
            raise e
    
    def mars_test_in_out(self, filename, fileIn, fileOut):
        child = subprocess.run(["java", "-jar", self.MARS_filepath, os.path.join(SOURCE_DIR, filename)], stdin=open(os.path.join(TEST_DIR, fileIn), "r"), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if child.returncode != 0:
            raise Exception(child.stderr.read())
        res = child.stdout.decode('utf-8')
        with open(os.path.join(TEST_DIR, fileOut), "r") as f:
            content = f.read()
        
        self.assertEqual(res.replace("\r", ""), content.replace("\r", ""))

    def mars_test_function_in_out(self, filename_tester, filename, fileIn, fileOut):
        child = subprocess.run(["java", "-jar", self.MARS_filepath, os.path.join(TEST_DIR, filename_tester), os.path.join(SOURCE_DIR, filename)], stdin=open(os.path.join(TEST_DIR, fileIn), "r"), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if child.returncode != 0:
            raise Exception(child.stderr.read())
        res = child.stdout.decode('utf-8')
        with open(os.path.join(TEST_DIR, fileOut), "r") as f:
            content = f.read()
        
        self.assertEqual(res.replace("\r", ""), content.replace("\r", ""))
