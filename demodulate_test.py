import unittest
from demodulate import demodulate, demodulate_num

class TestDemodulate(unittest.TestCase):
    def test_modulate_num(self):
        self.assertEqual((8, ""), demodulate_num("01101000"))
        self.assertEqual((0, ""), demodulate_num("010"))
        self.assertEqual((1, ""), demodulate_num("01100001"))

    def test_modulate(self):
        self.assertEqual(0, demodulate("010"))
        self.assertEqual(1, demodulate("01100001"))
        self.assertEqual(2, demodulate("01100010"))
        self.assertEqual(3, demodulate("01100011"))
        self.assertEqual([0], demodulate("1101000"))
        self.assertEqual([0,1], demodulate("11010110110000100"))
        self.assertEqual([[1,2],3], demodulate("11 11 01100001 11 01100010 00 11 01100011 00".replace(" ", "")))
        pass

if __name__ == "__main__":
    unittest.main()