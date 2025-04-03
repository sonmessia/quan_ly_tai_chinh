const express = require('express');
const router = express.Router();
const goalController = require('../controllers/goalController');

// Goal routes
router.get('/', goalController.getAllGoals);
router.get('/user/:userId', goalController.getUserGoals);
router.get('/user/:userId/status/:status', goalController.getGoalsByStatus);
router.get('/:id', goalController.getGoal);
router.post('/', goalController.createGoal);
router.put('/:id', goalController.updateGoal);
router.put('/:id/progress', goalController.updateGoalProgress);
router.delete('/:id', goalController.deleteGoal);

module.exports = router; 