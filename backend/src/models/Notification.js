const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  notification_id: {
    type: Number,
    required: true,
    unique: true
  },
  user_id: {
    type: Number,
    required: true,
    ref: 'User'
  },
  title: {
    type: String,
    required: true,
    trim: true
  },
  message: {
    type: String,
    required: true,
    trim: true
  },
  type: {
    type: String,
    required: true,
    enum: ['info', 'warning', 'success', 'error']
  },
  is_read: {
    type: Boolean,
    default: false
  },
  create_at: {
    type: Date,
    default: Date.now
  }
}, {
  collection: 'notifications'
});

module.exports = mongoose.model('Notification', notificationSchema); 