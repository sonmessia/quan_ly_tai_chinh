const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');

// Notification routes
router.get('/', notificationController.getAllNotifications);
router.get('/user/:userId', notificationController.getUserNotifications);
router.get('/user/:userId/unread', notificationController.getUnreadNotifications);
router.get('/:id', notificationController.getNotification);
router.post('/', notificationController.createNotification);
router.put('/:id/read', notificationController.markAsRead);
router.put('/user/:userId/read-all', notificationController.markAllAsRead);
router.delete('/:id', notificationController.deleteNotification);

module.exports = router; 