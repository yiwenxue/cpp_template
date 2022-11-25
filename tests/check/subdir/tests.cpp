#include <gtest/gtest.h>

auto multiply(double a, double b) -> double
{
    return a * b;
}

TEST(MultiplyTest, Double) // NOLINT
{
    EXPECT_EQ(6, multiply(2, 3));
    EXPECT_EQ(6, multiply(3, 2));
}