const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  category_id: {
    type: Number,
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true,
    trim: true
  },
  type: {
    type: String,
    required: true,
    enum: ['income', 'expense']
  },
  icon: {
    type: String,
    trim: true
  },
  color: {
    type: String,
    trim: true
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
  collection: 'categories'
});

// Update the update_at timestamp before saving
categorySchema.pre('save', function(next) {
  this.update_at = new Date();
  next();
});

module.exports = mongoose.model('Category', categorySchema); 