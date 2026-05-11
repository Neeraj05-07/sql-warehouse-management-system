-- ============================================================================
-- Triggers
-- ============================================================================

-- Objective:
-- Automatically manage inventory when a new order item is inserted.
--
-- Trigger Functions:
-- 1. Check stock availability
-- 2. Prevent insert if stock is insufficient
-- 3. Reduce inventory quantity
-- 4. Insert stock movement history
-- 5. Update inventory last_updated timestamp
-- ============================================================================


-- ============================================================================
-- Create Trigger
-- ============================================================================

