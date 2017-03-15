from os import environ
from time import sleep
from unittest import TestCase
import subprocess
from urllib.request import urlopen, URLError


class Onbuild(TestCase):
    def setUp(self):
        subprocess.check_call(['docker', 'build', '-t', 'onbuild-test', 'tests/onbuild'])
        subprocess.Popen(['docker', 'run', '--rm', '-p', '8000:8000', '--name', 'onbuild-test', 'onbuild-test'], stdout=subprocess.PIPE)

    def tearDown(self):
        subprocess.Popen(['docker', 'stop', 'onbuild-test'], stdout=subprocess.PIPE)

    def test_(self):
        for i in range(10):
            try:
                res = urlopen('http://localhost:8000')
                break
            except (URLError, ConnectionResetError):
                sleep(1)
        else:
            self.fail('Could not connect to the container')

        self.assertEqual(200, res.status)
