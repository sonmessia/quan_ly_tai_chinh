const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  users_id: {
    type: Number,
    required: true,
    unique: true
  },
  username: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },

  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  password: {
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
  collection: 'users' // Explicitly specify the collection name
});

// Update the update_at timestamp before saving
userSchema.pre('save', function(next) {
  this.update_at = new Date();
  next();
});

// Add a static method to check collection name
userSchema.statics.getCollectionName = function() {
  return this.collection.name;
};

const User = mongoose.model('User', userSchema);

// Log the collection name when the model is created
console.log('User model collection name:', User.getCollectionName());

module.exports = User; 