const mongoose = require('mongoose');

const goalSchema = new mongoose.Schema({
  goal_id: {
    type: Number,
    required: true,
    unique: true
  },
  user_id: {
    type: Number,
    required: true,
    ref: 'User'
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  target_amount: {
    type: Number,
    required: true
  },
  current_amount: {
    type: Number,
    default: 0
  },
  deadline: {
    type: Date,
    required: true
  },
  status: {
    type: String,
    enum: ['active', 'completed', 'cancelled'],
    default: 'active'
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
  collection: 'goals'
});

// Update the update_at timestamp before saving
goalSchema.pre('save', function(next) {
  this.update_at = new Date();
  next();
});

module.exports = mongoose.model('Goal', goalSchema); 