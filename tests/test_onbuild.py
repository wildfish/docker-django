import uuid
from os import environ
from time import sleep
from unittest import TestCase
import subprocess
from urllib.request import urlopen, URLError


class Onbuild(TestCase):
    def setUp(self):
        self.container_name = 'onbuild-test-' + uuid.uuid4().hex
        subprocess.check_call(['docker', 'build', '-t', 'onbuild-test', 'tests/onbuild'], stdout=subprocess.DEVNULL)

    def test_server_can_be_accessed(self):
        subprocess.Popen(['docker', 'run', '--rm', '-p', '8000:8000', '--name', self.container_name, 'onbuild-test'], stdout=subprocess.DEVNULL)

        try:
            for i in range(10):
                try:
                    res = urlopen('http://localhost:8000')
                    break
                except (URLError, ConnectionResetError):
                    sleep(1)
            else:
                self.fail('Could not connect to the container')

            self.assertEqual(200, res.status)
        finally:
            subprocess.call(['docker', 'stop', self.container_name], stdout=subprocess.DEVNULL)
            subprocess.call(['docker', 'rm', self.container_name], stdout=subprocess.DEVNULL)

    def test_user_is_django(self):
        p = subprocess.Popen(['docker', 'run',  '--rm', '--name', self.container_name, 'onbuild-test', 'whoami'], stdout=subprocess.PIPE)
        out, err = p.communicate()

        self.assertEqual('django', out.strip().decode())
