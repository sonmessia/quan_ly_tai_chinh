const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// User routes
router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUser);
router.post('/login', userController.getUserByCredentials);  // For login
router.post('/', userController.createUser);  // For user creation
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

module.exports = router;