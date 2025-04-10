import React, { useState ,useEffect} from "react";
import "../../Injectable.css";
import axios from 'axios';


const InjectableMeds=()=>{
    const [injectableInventory,setInjectableInventory] = useState([]);
    useEffect(()=>{
            const inventoryFetch = async()=>{
                try{
                    const injectables = await axios.get('http://localhost:3003/get-medicine-inventory',{
                        params:{med_type:'injectable'}
                    });
                    const res = injectables.data.data;
                    setInjectableInventory(res);
                    console.log(injectables.data.data);
                }catch(error){
                    console.log('Error fetching injectables inventory',error);
                }
        }
        inventoryFetch();
    },[])

    return(
        <>
        <div className="min-h-screen overflow-auto">
        {injectableInventory.map((item, index) => (
        <div key={`${item.medicine_name}-${item.category_name}-${index}`} className="item">
            <div className="item-details">
            <div className="item-name">
                <h3>Medicine</h3>
                {item.medicine_name}
            </div>
            <div className="item-category">
                <h3>Category</h3>
                <p>{item.category_name}</p>
                </div>
            </div>
            <div className="item-stock">
                <h3>Stock</h3>
                <p className={item.quantity <= 50 ? 'low-stock' : 'normal-stock'}>
                    <span className="stock-icon">🧺</span>{item.quantity}
                </p>
            </div>
        </div>
        ))}

        </div>
        </>
    );
};

export default InjectableMeds;