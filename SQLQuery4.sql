-- Views consumed by the Power BI dashboard and exported to Prediction_Data.xlsx for the notebook.
-- CREATE VIEW must be the only statement in its batch, so each one is separated by GO.

USE db_Churn;
GO

-- Existing customers with a known outcome (training data for the model)
CREATE VIEW vw_ChurnData AS
    SELECT * FROM prod_Churn WHERE Customer_Status IN ('Churned', 'Stayed');
GO

-- Newly joined customers (the model predicts which of these will churn)
CREATE VIEW vw_JoinData AS
    SELECT * FROM prod_Churn WHERE Customer_Status = 'Joined';
GO
