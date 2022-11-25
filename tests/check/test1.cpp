#include <gtest/gtest.h>

auto add(int a, int b) -> int
{
    return a + b;
}

TEST(AddTest, PositiveNos) // NOLINT
{
    EXPECT_EQ(5, add(2, 3));

    EXPECT_EQ(5, add(3, 2));
}