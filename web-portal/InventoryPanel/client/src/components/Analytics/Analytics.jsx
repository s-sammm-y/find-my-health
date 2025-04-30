import React, { useState, useEffect } from "react";
import AnalyticsChart from './AnalyticsChart';
import axios from "axios"
import "./Analytics.css"

function Analytics(){
    const [inventoryData,setInventoryData] = useState([]);
    const [medicineCategory,setMedicineCategory] = useState([]);
    useEffect(()=>{
        const fetchInventory= async ()=>{
            try{
                const response = await axios.get("http://localhost:3003/api/inventory");
                setInventoryData(response.data);
                //console.log(response.data);

                const medicineQuantity = await axios.get("http://localhost:3003/medicineCategoryQuantity")
                setMedicineCategory(medicineQuantity.data.data);
                //console.log(medicineQuantity.data.data)
            }catch(err){
                console.log("Error fetching inventory in frontend",err);
            }
        }

        fetchInventory();
    },[]);

    const inventoryAccuracy = 0.881;

    const totalStockValue = inventoryData?.reduce((acc, item) => {
        const unitPrice = item.unitPrice || 100;
        return acc + (unitPrice * item.quantity);
      }, 0);

    return(
        <>
      <div className="flex flex-row gap-6">
        {/* Left side */}
        <div className="flex flex-col text-center items-center rounded-lg gap-6 w-1/3">
          {/* Stock Check */}
          <div className="stock-check bg-white text-center rounded-lg">
            <h2 className="text-xl font-semibold">Stock Check</h2>
            <span className="text-sm text-gray-500">42 days since last checked</span>

            <div className="inventory-accuracy flex flex-col mt-6 items-center">
              <h2 className="text-lg font-semibold mb-2">Inventory Accuracy</h2>
              <div className="relative w-24 h-24">
                <svg className="transform -rotate-90" viewBox="0 0 100 100">
                  <circle
                    cx="50"
                    cy="50"
                    r="45"
                    stroke="#e5e7eb"
                    strokeWidth="10"
                    fill="transparent"
                  />
                  <circle
                    cx="50"
                    cy="50"
                    r="45"
                    stroke="#10b981"
                    strokeWidth="10"
                    fill="transparent"
                    strokeDasharray="282.6"
                    strokeDashoffset={(1 - inventoryAccuracy) * 282.6}
                    strokeLinecap="round"
                  />
                </svg>
                <div className="absolute inset-0 flex items-center justify-center text-xl font-bold text-emerald-500">
                  {(inventoryAccuracy * 100).toFixed(1)}%
                </div>
              </div>
            </div>
          </div>

          {/* Warehouse */}
          <div className="warehouse bg-white rounded-lg p-4">
            <h2 className="text-xl font-semibold mb-4">Warehouse</h2>

            <div className="utilization mb-6">
              <div className="w-full bg-gray-300 rounded-full h-4 mb-2">
                <div
                  className="bg-blue-600 h-4 rounded-full"
                  style={{ width: "81%" }}
                ></div>
              </div>
              <span className="text-sm font-semibold">81% Utilization</span>
            </div>

            <div className="value-of-stock">
              <span className="text-2xl font-bold">{(totalStockValue / 1_000_000).toFixed(2)}M</span>
              <br />
              <span className="text-xl text-gray-600 ">Value of stock</span>
            </div>
          </div>
        </div>

        {/* Right side */}
        <div className="flex flex-col flex-1 gap-5">
          {/* Stock Table */}
          <div className="stock-table">
            <h1 className="text-2xl font-bold" style={{marginBottom:"10px"}}>In Stock</h1>
            <div className="overflow-y-auto max-h-96 flex flex-col gap-2">
              <div className="flex flex-col gap-2">
                {/* Header Row */}
                <div className="flex justify-between bg-gray-100 px-4 py-2 rounded font-semibold text-sm">
                  <span className="w-1/4">Category</span>
                  <span className="w-1/4 text-center">Quantity</span>
                  <span className="w-1/4 text-center">Unit Price</span>
                  <span className="w-1/4 text-right">Stock Value</span>
                </div>

                {/* Data Rows */}
                {[
                  ...inventoryData.map((item) => ({
                    key: `item-${item.item_id}`,
                    category: item.category,
                    quantity: item.quantity,
                    unitPrice: 100,
                  })),
                  ...medicineCategory.map((cat, index) => ({
                    key: `cat-${index}`,
                    category: cat.category,
                    quantity: cat.total_quantity,
                    unitPrice: 100,
                  })),
                ].map((row) => (
                  <div
                    key={row.key}
                    className="flex justify-between items-center px-4 py-2 rounded text-lg hover:bg-gray-50"
                  >
                    <span className="w-1/4">{row.category}</span>
                    <span className="w-1/4 text-center">{row.quantity}</span>
                    <span className="w-1/4 text-center">${row.unitPrice}</span>
                    <span className="w-1/4 text-right">
                      ${(row.unitPrice * row.quantity).toFixed(2)}
                    </span>
                  </div>
                ))}
              </div>
              </div>
          </div>

          {/* Returns Section */}
          <div className="returns bg-white rounded-lg shadow p-4">
            <h2 className="text-xl font-semibold " style={{marginBottom:"20px"}}>Returns</h2>
            <AnalyticsChart/>
          </div>
        </div>
      </div>
    </>
    )
}

export default Analytics;