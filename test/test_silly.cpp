#include "gtest/gtest.h"

extern "C" {
#include "../silly.h"
}

TEST(SillyTest, PostiveIntegers)
{
    ASSERT_EQ(0u,   silly_square(0));
    ASSERT_EQ(16u,  silly_square(4));
    ASSERT_EQ(25u,  silly_square(5));
}

