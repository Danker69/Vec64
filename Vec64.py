# Created by whibri | GitHub: @Danker69

import math

def lerp(start, finish, alpha):
    return start + ((finish - start) * alpha)

class Vec64:
    def __init__(self, x, y, z) -> None:
        self.X = x or 0
        self.Y = y or 0
        self.Z = z or 0

    def __str__(self) -> str:
        return str(self.X) + ", " + str(self.Y) + ", " + str(self.Z)

    def __concat__(self, value) -> str:
        if not value.X:
            print("Concatenated value was not a Vec64!")
        return (str(self.X) + ", " + str(self.Y) + ", " + str(self.Z) + "\n" +
                str(value.X) + ", " + str(value.Y) + ", " + str(value.Z))

    def __eq__(self, value) -> bool:
        if self.X == value.X and self.Y == value.Y and self.Z == value.Z:
            return True
        return False
            
    def __neg__(self):
        return Vec64(-self.X, -self.Y, -self.Z)

    def __add__(self, value):
        if isinstance(value, (int, float)):
            return Vec64(self.X + value, self.Y + value, self.Z + value)
        if isinstance(self, (int, float)):
            return Vec64(value.X + self, value.Y + self, value.Z + self)

        x = self.X + value.X
        y = self.Y + value.Y
        z = self.Z + value.Z

        return Vec64(x, y ,z)

    def __sub__(self, value):
        if isinstance(value, (int, float)):
            return Vec64(self.X - value, self.Y - value, self.Z - value)
        if isinstance(self, (int, float)):
            return Vec64(value.X - self, value.Y - self, value.Z - self)

        x = self.X - value.X
        y = self.Y - value.Y
        z = self.Z - value.Z

        return Vec64(x, y ,z)

    def __mul__(self, value):
        if isinstance(value, (int, float)):
            return Vec64(self.X * value, self.Y * value, self.Z * value)
        if isinstance(self, (int, float)):
            return Vec64(value.X * self, value.Y * self, value.Z * self)

        x = self.X * value.X
        y = self.Y * value.Y
        z = self.Z * value.Z

        return Vec64(x, y ,z)

    def __truediv__(self, value):
        if isinstance(value, (int, float)):
            return Vec64(self.X / value, self.Y / value, self.Z / value)
        if isinstance(self, (int, float)):
            return Vec64(value.X / self, value.Y / self, value.Z / self)

        x = self.X / value.X
        y = self.Y / value.Y
        z = self.Z / value.Z

        return Vec64(x, y ,z)

    def __pow__(self, value):
        if isinstance(value, (int, float)):
            return Vec64(self.X ** value, self.Y ** value, self.Z ** value)
        if isinstance(self, (int, float)):
            return Vec64(value.X ** self, value.Y ** self, value.Z ** self)

        x = self.X ** value.X
        y = self.Y ** value.Y
        z = self.Z ** value.Z

        return Vec64(x, y ,z)

    def Magnitude(self):
        return math.sqrt(self.X^2 + self.Y^2 + self.Z^2)

    def Unit(self):
        return Vec64(
            self.X / self.Magnitude(),
            self.Y / self.Magnitude(),
            self.Z / self.Magnitude()
        )

    def Cross(self, vector):
            return Vec64(
                self.Y * vector.Z - self.Z * vector.Y,
                self.Z * vector.X - self.X * vector.Z,
                self.X * vector.Y - self.Y * vector.X
            )

    def Dot(self, vector):
        return (
            self.X * vector.X +
            self.Y * vector.Y +
            self.Z * vector.Z
        )

    def FuzzyEz(self, vector, epsilon) -> bool:
        x = self.X - vector.X
        y = self.Y - vector.Y
        z = self.Z - vector.Z

        new = Vec64(x, y, z)
        mag = new.Magnitude()

        if mag <= epsilon:
            return True
        return False

    def Lerp(self, vector, alpha):
        return Vec64(
            lerp(self.X, vector.X, alpha),
            lerp(self.Y, vector.Y, alpha),
            lerp(self.Z, vector.Z, alpha)
        )

    def Max(self, *vecs):
        maxn = max(self.X, self.Y, self.Z)
        for vec in vecs:
            maxn = max(maxn, vec.AsTuple())
        return Vec64(maxn, maxn, maxn)

    def Min(self, *vecs):
        minn = min(self.X, self.Y, self.Z)
        for vec in vecs:
            maxn = min(minn, vec.AsTuple())
        return Vec64(minn, minn, minn)

    def AsTuple(self):
        return self.X, self.Y, self.Z

    def zero():
        return Vec64(0, 0, 0)

    def one():
        return Vec64(1, 1, 1)

    def xAxis():
        return Vec64(1, 0, 1)

    def yAxis():
        return Vec64(0, 1, 0)

    def zAxis():
        return Vec64(0, 0, 1)