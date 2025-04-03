const User = require('../models/User');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    console.log('Attempting to fetch all users...');
    console.log('Collection name:', User.getCollectionName());
    
    // Try to find users
    const users = await User.find();
    console.log('Found users:', users);
    
    if (!users || users.length === 0) {
      console.log('No users found in the database');
      return res.status(200).json([]);
    }
    res.status(200).json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ message: error.message });
  }
};

// Get single user by ID or users_id
exports.getUser = async (req, res) => {
  try {
    let user;
    // Check if the ID is a MongoDB ObjectId
    if (req.params.id.match(/^[0-9a-fA-F]{24}$/)) {
      user = await User.findById(req.params.id);
    } else {
      // Try to find by users_id
      user = await User.findOne({ users_id: parseInt(req.params.id) });
    }
    
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get user by email and password
exports.getUserByCredentials = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Check if email and password are provided
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }
    
    // Find user by email
    const user = await User.findOne({ email });
    
    // User not found
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    
    // Compare passwords
    const isPasswordValid = await bcrypt.compare(password, user.password);
    
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    
    // Return user if credentials are valid
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create user
exports.createUser = async (req, res) => {
  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(req.body.password, 10);

    // Get the latest users_id
    const latestUser = await User.findOne().sort({ users_id: -1 });
    const nextUserId = latestUser ? latestUser.users_id + 1 : 1;

    const user = new User({
      ...req.body,
      password: hashedPassword, // Store the hashed password
      users_id: nextUserId
    });

    const newUser = await user.save();
    res.status(201).json(newUser);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Update user
exports.updateUser = async (req, res) => {
  try {
    let user;
    // Check if the ID is a MongoDB ObjectId
    if (req.params.id.match(/^[0-9a-fA-F]{24}$/)) {
      if (req.body.password) {
        // Hash the new password if provided
        req.body.password = await bcrypt.hash(req.body.password, 10);
      }
      user = await User.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true, runValidators: true }
      );
    } else {
      // Try to update by users_id
      if (req.body.password) {
        req.body.password = await bcrypt.hash(req.body.password, 10);
      }
      user = await User.findOneAndUpdate(
        { users_id: parseInt(req.params.id) },
        req.body,
        { new: true, runValidators: true }
      );
    }

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json(user);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Delete user
exports.deleteUser = async (req, res) => {
  try {
    let user;
    // Check if the ID is a MongoDB ObjectId
    if (req.params.id.match(/^[0-9a-fA-F]{24}$/)) {
      user = await User.findByIdAndDelete(req.params.id);
    } else {
      // Try to delete by users_id
      user = await User.findOneAndDelete({ users_id: parseInt(req.params.id) });
    }

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 