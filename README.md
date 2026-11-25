# Customer Churn Prediction & Analytics

## Overview

Customer churn significantly impacts revenue and long-term business growth. This project analyzes customer behavior, identifies churn patterns, and predicts which newly joined customers are likely to leave. It combines SQL Server for data cleaning and preparation, a Random Forest model in Python for prediction, and an interactive Power BI dashboard for reporting.

---

## Features

- Data quality checks and null handling in SQL Server
- Cleaned production table and reporting views
- Churn prediction using a Random Forest Classifier
- Comparison against a Logistic Regression baseline
- Feature importance analysis
- Predicted list of at-risk new customers exported to CSV
- Interactive Power BI dashboard

---

## Tech Stack

- SQL Server (T-SQL)
- Python: Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn
- Jupyter Notebook (runs locally or in Google Colab)
- Power BI

---

## Dataset Attributes

Each row is one customer of a telecom provider in India. The columns are:

| Group | Columns |
|---|---|
| Identity | Customer_ID |
| Demographics | Gender, Age, Married, State |
| Account | Number_of_Referrals, Tenure_in_Months, Value_Deal, Contract, Paperless_Billing, Payment_Method |
| Services | Phone_Service, Multiple_Lines, Internet_Service, Internet_Type, Online_Security, Online_Backup, Device_Protection_Plan, Premium_Support, Streaming_TV, Streaming_Movies, Streaming_Music, Unlimited_Data |
| Billing | Monthly_Charge, Total_Charges, Total_Refunds, Total_Extra_Data_Charges, Total_Long_Distance_Charges, Total_Revenue |
| Outcome | Customer_Status (Stayed / Churned / Joined), Churn_Category, Churn_Reason |

---

## Project Workflow

### 1. Data Preparation (SQL Server)

The raw data is loaded into a staging table `stg_Churn` in a database named `db_Churn`.

| File | Purpose |
|---|---|
| `SQLQuery1.sql` | Preview the staging table |
| `SQLQuery2.sql` | Count null values in every column |
| `SQLQuery3.sql` | Replace nulls with defaults (`'No'`, `'None'`, `'Others'`) and write the cleaned data to `prod_Churn` |
| `SQLQuery4.sql` | Create the views `vw_ChurnData` (Stayed + Churned customers) and `vw_JoinData` (newly Joined customers) |
| `SQLQuery5.sql` | Preview the cleaned production table |

### 2. Machine Learning Model (`Random_Forest_Codes.ipynb`)

1. Load the `vw_ChurnData` and `vw_JoinData` sheets from `Prediction_Data.xlsx`
2. Drop ID and churn-reason columns, label-encode the categorical columns
3. Train/test split (80/20)
4. Train a Random Forest Classifier (100 trees)
5. Evaluate with a confusion matrix and classification report
6. Plot feature importances
7. Predict churn for newly joined customers and save those predicted to churn to `Predictions.csv`
8. Compare against a Logistic Regression baseline

### 3. Power BI Dashboard (`Churn_Analysis_visualization.pbix`)

Built on the SQL views and the prediction output, covering churn overview, customer demographics, revenue, service usage and predicted at-risk customers.

---

## Results

Test set: 1,202 customers (847 stayed, 355 churned).

| Model | Accuracy | Churn Precision | Churn Recall | Churn F1 |
|---|---|---|---|---|
| **Random Forest** | **0.84** | **0.78** | 0.65 | **0.71** |
| Logistic Regression | 0.80 | 0.66 | 0.65 | 0.65 |

Random Forest performs better overall, mainly by raising false alarms less often. Both models find about 65% of actual churners, so recall is the main area to improve.

### Most Important Features

According to the Random Forest feature importances, the strongest predictors of churn are:

1. Contract
2. Total_Revenue
3. Total_Charges
4. Monthly_Charge
5. Total_Long_Distance_Charges
6. Age
7. Tenure_in_Months

The individual add-on services (streaming, backup, unlimited data) and Phone_Service contribute very little.

---

## Repository Structure

```text
churn_analysis/
├── Random_Forest_Codes.ipynb
├── Churn_Analysis_visualization.pbix
├── SQLQuery1.sql
├── SQLQuery2.sql
├── SQLQuery3.sql
├── SQLQuery4.sql
├── SQLQuery5.sql
├── requirements.txt
├── LICENSE
└── README.md
```

---

## How to Run

### 1. Clone the repository

```bash
git clone https://github.com/abhideep193/churn_analysis.git
cd churn_analysis
```

### 2. Prepare the data in SQL Server

1. Create a database named `db_Churn` and import the raw customer data into a table named `stg_Churn`.
2. Run `SQLQuery2.sql` to check for nulls, then `SQLQuery3.sql` and `SQLQuery4.sql` in that order.
3. Export the `vw_ChurnData` and `vw_JoinData` views as two sheets with those names in an Excel file named `Prediction_Data.xlsx`.

> The raw dataset and `Prediction_Data.xlsx` are not included in this repository.

### 3. Run the notebook

The notebook detects where it is running and works both locally and in Google Colab.

**Locally**

1. Put `Prediction_Data.xlsx` in the same folder as the notebook.
2. Install the dependencies and start Jupyter:

   ```bash
   pip install -r requirements.txt
   jupyter notebook
   ```

3. Open `Random_Forest_Codes.ipynb` and run all cells.
4. The predicted churners are saved to `Predictions.csv` in the same folder.

If you keep the data somewhere else, set the `CHURN_DATA_DIR` environment variable to that folder before starting Jupyter. The output is written to the same folder.

**In Google Colab**

1. Upload `Prediction_Data.xlsx` to the root of your Google Drive (`MyDrive`).
2. Open the notebook in Colab and run all cells. Allow Drive access when asked.
3. The predictions are saved to `MyDrive/Predictions.csv`.

### 4. Open the dashboard

Open `Churn_Analysis_visualization.pbix` in Power BI Desktop. To refresh the data, point its data sources at your own `db_Churn` database and `Predictions.csv`.

---

## Future Enhancements

- Tune hyperparameters with GridSearchCV and handle class imbalance to improve churn recall
- Try XGBoost and LightGBM
- Make the notebook read directly from SQL Server
- Serve predictions through a Flask/FastAPI API
- Automate the dashboard refresh

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## Author

GitHub: [abhideep193](https://github.com/abhideep193)
