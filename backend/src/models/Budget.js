const mongoose = require('mongoose');

const budgetSchema = new mongoose.Schema({
  budget_id: {
    type: Number,
    required: true,
    unique: true
  },
  user_id: {
    type: Number,
    required: true,
    ref: 'User'
  },
  category_id: {
    type: Number,
    required: true,
    ref: 'Category'
  },
  amount: {
    type: Number,
    required: true
  },
  period: {
    type: String,
    required: true,
    enum: ['daily', 'weekly', 'monthly', 'yearly']
  },
  start_date: {
    type: Date,
    required: true
  },
  end_date: {
    type: Date,
    required: true
  },
  create_at: {
    type: Date,
    default: Date.now
  },
  update_at: {
    type: Date,
    default: Date.now
  }
}, {
  collection: 'budgets'
});

// Update the update_at timestamp before saving
budgetSchema.pre('save', function(next) {
  this.update_at = new Date();
  next();
});

module.exports = mongoose.model('Budget', budgetSchema); 