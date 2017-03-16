from os import environ
from unittest import TestCase
import subprocess


class Node(TestCase):
    def test_nvmrc_is_present_for_bootstrap_node_call___node_version_is_as_expected(self):
        subprocess.check_call(['docker', 'build', '-t', 'nvm-test', 'tests/nvmrc'], stdout=subprocess.DEVNULL)
        p = subprocess.Popen(['docker', 'run', 'nvm-test', 'node', '--version'], stdout=subprocess.PIPE)
        out, err = p.communicate()

        actual = out.strip()

        self.assertEqual(b'v5.10.1', actual)

    def test_node_version_is_as_expected(self):
        p = subprocess.Popen(['docker', 'run', 'wildfish/django', 'node', '--version'], stdout=subprocess.PIPE)
        out, err = p.communicate()

        actual = out.strip()

        self.assertEqual(environ.get('NODE_VERSION').encode(), actual)
