import unittest
from modulate import modulate

class TestModulate(unittest.TestCase):
    def test_modulate(self):
        self.assertEqual("010", modulate(0))
        self.assertEqual("01100001", modulate(1))
        self.assertEqual("01100010", modulate(2))
        self.assertEqual("01100011", modulate(3))
        self.assertEqual("01101000", modulate(8))
        self.assertEqual("01101111", modulate(15))
        self.assertEqual("10101000", modulate(-8))
        self.assertEqual("1101000", modulate([0]))
        self.assertEqual("11010110110000100", modulate([0,1]))
        self.assertEqual("11 11 01100001 11 01100010 00 11 01100011 00".replace(" ", ""), modulate([[1,2],3]))
        pass

if __name__ == "__main__":
    unittest.main()