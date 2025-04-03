const express = require('express');
const router = express.Router();
const budgetController = require('../controllers/budgetController');

// Budget routes
router.get('/', budgetController.getAllBudgets);
router.get('/user/:userId', budgetController.getUserBudgets);
router.get('/user/:userId/period/:period', budgetController.getBudgetsByPeriod);
router.get('/:id', budgetController.getBudget);
router.post('/', budgetController.createBudget);
router.put('/:id', budgetController.updateBudget);
router.delete('/:id', budgetController.deleteBudget);

module.exports = router; 