from unittest import TestCase
import subprocess


class Node(TestCase):
    def test_node_version_is_as_expeted(self):
        with subprocess.Popen(['node', '--version'], stdout=subprocess.PIPE) as p:
            actual = p.stdout.read().strip()

            self.assertEqual(b'v5.10.1', actual)
