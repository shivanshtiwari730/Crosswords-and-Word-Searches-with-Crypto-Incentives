// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WordPuzzleRewards {
    // Owner of the contract
    address public owner;

    // Mapping to track players' scores and rewards
    mapping(address => uint256) public playerScores;
    mapping(address => uint256) public playerRewards;

    // Reward token per correct answer
    uint256 public rewardPerCorrectAnswer = 1 ether;

    // Event declarations
    event PuzzleSolved(address indexed player, uint256 score, uint256 reward);
    event RewardClaimed(address indexed player, uint256 amount);

    // Modifier to restrict certain actions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to update reward per correct answer
    function setRewardPerCorrectAnswer(uint256 newReward) external onlyOwner {
        rewardPerCorrectAnswer = newReward;
    }

    // Function to submit a correct answer and update score
    function submitCorrectAnswer(address player, uint256 correctAnswers) external onlyOwner {
        uint256 score = correctAnswers;
        uint256 reward = correctAnswers * rewardPerCorrectAnswer;

        playerScores[player] += score;
        playerRewards[player] += reward;

        emit PuzzleSolved(player, score, reward);
    }

    // Function for players to claim their rewards
    function claimRewards() external {
        uint256 reward = playerRewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        playerRewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);

        emit RewardClaimed(msg.sender, reward);
    }

    // Fallback function to accept Ether deposits
    receive() external payable {}

    // Function for the owner to withdraw funds
    function withdrawFunds(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient funds");
        payable(owner).transfer(amount);
    }
}
