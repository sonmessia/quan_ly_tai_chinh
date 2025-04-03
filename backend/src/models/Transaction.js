const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
  transaction_id: {
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
    ref: 'Category'
  },
  amount: {
    type: Number,
    required: true
  },
  description: {
    type: String,
    trim: true
  },
  type: {
    type: String,
    required: true,
    enum: ['income', 'expense']
  },
  status: {
    type: String,
    required: true,
    enum: ['pending', 'completed', 'failed', 'recurring', 'scheduled']
  },
  payment_method: {
    type: String,
    required: true,
    enum: ['creditCard', 'check', 'bankTransfer', 'cash', 'eWallet', 'crypto']
  },
  category_name: {
    type: String,
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
  collection: 'transactions'
});

// Update the update_at timestamp before saving
transactionSchema.pre('save', function(next) {
  this.update_at = new Date();
  next();
});

module.exports = mongoose.model('Transaction', transactionSchema); 