const Goal = require('../models/Goal');

// Get all goals
exports.getAllGoals = async (req, res) => {
  try {
    const goals = await Goal.find();
    res.status(200).json(goals);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get goals by user_id
exports.getUserGoals = async (req, res) => {
  try {
    const goals = await Goal.find({ user_id: req.params.userId });
    res.status(200).json(goals);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get goals by status
exports.getGoalsByStatus = async (req, res) => {
  try {
    const goals = await Goal.find({ 
      user_id: req.params.userId,
      status: req.params.status
    });
    res.status(200).json(goals);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get single goal
exports.getGoal = async (req, res) => {
  try {
    const goal = await Goal.findOne({ goal_id: req.params.id });
    if (!goal) {
      return res.status(404).json({ message: 'Goal not found' });
    }
    res.status(200).json(goal);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create goal
exports.createGoal = async (req, res) => {
  try {
    // Get the latest goal_id
    const latestGoal = await Goal.findOne().sort({ goal_id: -1 });
    const nextGoalId = latestGoal ? latestGoal.goal_id + 1 : 1;

    const goal = new Goal({
      ...req.body,
      goal_id: nextGoalId
    });

    const newGoal = await goal.save();
    res.status(201).json(newGoal);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update goal
exports.updateGoal = async (req, res) => {
  try {
    const goal = await Goal.findOneAndUpdate(
      { goal_id: req.params.id },
      req.body,
      { new: true, runValidators: true }
    );

    if (!goal) {
      return res.status(404).json({ message: 'Goal not found' });
    }
    res.status(200).json(goal);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update goal progress
exports.updateGoalProgress = async (req, res) => {
  try {
    const goal = await Goal.findOne({ goal_id: req.params.id });
    if (!goal) {
      return res.status(404).json({ message: 'Goal not found' });
    }

    goal.current_amount = req.body.current_amount;
    
    // Check if goal is completed
    if (goal.current_amount >= goal.target_amount) {
      goal.status = 'completed';
    }

    const updatedGoal = await goal.save();
    res.status(200).json(updatedGoal);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete goal
exports.deleteGoal = async (req, res) => {
  try {
    const goal = await Goal.findOneAndDelete({ goal_id: req.params.id });
    if (!goal) {
      return res.status(404).json({ message: 'Goal not found' });
    }
    res.status(200).json({ message: 'Goal deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 