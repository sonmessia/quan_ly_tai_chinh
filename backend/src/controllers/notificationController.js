const Notification = require('../models/Notification');

// Get all notifications
exports.getAllNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find();
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get notifications by user_id
exports.getUserNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ user_id: req.params.userId });
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get unread notifications
exports.getUnreadNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ 
      user_id: req.params.userId,
      is_read: false
    });
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get single notification
exports.getNotification = async (req, res) => {
  try {
    const notification = await Notification.findOne({ notification_id: req.params.id });
    if (!notification) {
      return res.status(404).json({ message: 'Notification not found' });
    }
    res.status(200).json(notification);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create notification
exports.createNotification = async (req, res) => {
  try {
    // Get the latest notification_id
    const latestNotification = await Notification.findOne().sort({ notification_id: -1 });
    const nextNotificationId = latestNotification ? latestNotification.notification_id + 1 : 1;

    const notification = new Notification({
      ...req.body,
      notification_id: nextNotificationId
    });

    const newNotification = await notification.save();
    res.status(201).json(newNotification);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Mark notification as read
exports.markAsRead = async (req, res) => {
  try {
    const notification = await Notification.findOneAndUpdate(
      { notification_id: req.params.id },
      { is_read: true },
      { new: true }
    );

    if (!notification) {
      return res.status(404).json({ message: 'Notification not found' });
    }
    res.status(200).json(notification);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Mark all notifications as read
exports.markAllAsRead = async (req, res) => {
  try {
    await Notification.updateMany(
      { user_id: req.params.userId, is_read: false },
      { is_read: true }
    );
    res.status(200).json({ message: 'All notifications marked as read' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete notification
exports.deleteNotification = async (req, res) => {
  try {
    const notification = await Notification.findOneAndDelete({ notification_id: req.params.id });
    if (!notification) {
      return res.status(404).json({ message: 'Notification not found' });
    }
    res.status(200).json({ message: 'Notification deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}; 