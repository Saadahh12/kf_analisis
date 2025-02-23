CREATE OR REPLACE TABLE kimia_farma.analisis AS
SELECT 
  ft.transaction_id,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  ft.price AS actual_price,
  ft.discount_percentage,

  -- Hitung persentase gross laba berdasarkan ketentuan
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentasi_gross_laba,

  -- Hitung net sales (harga setelah diskon)
  ft.price * (1 - ft.discount_percentage / 100) AS net_sales,

  -- Hitung net profit (net sales * persentasi gross laba)
  (ft.price * (1 - ft.discount_percentage / 100)) * 
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS net_profit

FROM 
  kimia_farma.kf_final_transaction ft
JOIN 
  kimia_farma.kf_kantor_cabang kc ON ft.branch_id = kc.branch_id
JOIN 
  kimia_farma.kf_product p ON ft.product_id = p.product_id
JOIN
  kimia_farma.kf_inventory inv ON ft.product_id = inv.product_id AND ft.branch_id = inv.branch_id
