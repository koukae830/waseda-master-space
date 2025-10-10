class Solution {
    public int[] twoSum(int[] nums, int target) {
        if (nums.length <= 1) {
            return new int[0];
        }
        int i = 0, j = nums.length - 1;
        while (i < j) {
            if ((nums[i] + nums[j] ) == target) {
                return new int[]{i,j};
            }
        }
        // no answer
        return new int[0];
    }
}