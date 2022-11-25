#include <gtest/gtest.h>

auto multiply(float a, float b) -> float
{
    return a * b;
}

// test multiply
TEST(MultiplyTest, Float) // NOLINT
{
    EXPECT_EQ(6, multiply(2, 3));

    EXPECT_EQ(6, multiply(3, 2));
}
