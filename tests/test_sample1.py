import unittest


class TestStringMethods(unittest.TestCase):

    def test_upper(self):
        print ('this is the 2nd message from fork repo!')
        self.assertEqual('foo'.upper(), 'FOO')

    def test_isupper(self):
        self.assertTrue('FOO'.isupper())
        self.assertFalse('Foo'.isupper())

    def test_split(self):
        s = 'hello world'
        self.assertEqual(s.split(), ['hello', 'world'])
        # check that s.split fails when the separator is not a string
        with self.assertRaises(TypeError):
            s.split(2)

    def test_file1_method1(self):
        x = 2
        x = 6
        y = 6
        # assert x+1 == y,"test failed"
        assert x == y, "test failed"

    def test_file1_method2(self):
        x = 5
        y = 6
        assert x + 1 == y, "test failed without any reason! :)) "


if __name__ == '__main__':
    print ('This is a message from forked repo')
    unittest.main()
