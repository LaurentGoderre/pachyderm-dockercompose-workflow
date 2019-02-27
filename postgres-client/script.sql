SELECT
  p.ProductID,
  p.SafetyStockLevel,
  i.Quantity
FROM
  Production.ProductInventory i
  INNER JOIN Production.Product p ON i.ProductID = p.ProductID
WHERE i.Quantity < p.SafetyStockLevel;
