const Budget = require('../models/Budget');

// Get all budgets
exports.getAllBudgets = async (req, res) => {
  try {
    const budgets = await Budget.find();
    res.status(200).json(budgets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get budgets by user_id
exports.getUserBudgets = async (req, res) => {
  try {
    const budgets = await Budget.find({ user_id: req.params.userId });
    res.status(200).json(budgets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get budgets by period
exports.getBudgetsByPeriod = async (req, res) => {
  try {
    const budgets = await Budget.find({ 
      user_id: req.params.userId,
      period: req.params.period
    });
    res.status(200).json(budgets);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get single budget
exports.getBudget = async (req, res) => {
  try {
    const budget = await Budget.findOne({ budget_id: req.params.id });
    if (!budget) {
      return res.status(404).json({ message: 'Budget not found' });
    }
    res.status(200).json(budget);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create budget
exports.createBudget = async (req, res) => {
  try {
    // Get the latest budget_id
    const latestBudget = await Budget.findOne().sort({ budget_id: -1 });
    const nextBudgetId = latestBudget ? latestBudget.budget_id + 1 : 1;

    const budget = new Budget({
      ...req.body,
      budget_id: nextBudgetId
    });

    const newBudget = await budget.save();
    res.status(201).json(newBudget);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update budget
exports.updateBudget = async (req, res) => {
  try {
    const budget = await Budget.findOneAndUpdate(
      { budget_id: req.params.id },
      req.body,
      { new: true, runValidators: true }
    );

    if (!budget) {
      return res.status(404).json({ message: 'Budget not found' });
    }
    res.status(200).json(budget);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete budget
exports.deleteBudget = async (req, res) => {
  try {
    const budget = await Budget.findOneAndDelete({ budget_id: req.params.id });
    if (!budget) {
      return res.status(404).json({ message: 'Budget not found' });
    }
    res.status(200).json({ message: 'Budget deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 