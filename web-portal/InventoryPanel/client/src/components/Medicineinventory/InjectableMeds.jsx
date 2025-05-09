import React, { useState ,useEffect} from "react";
import "./medicineInventory.css";
import { faPen } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import axios from 'axios';


const InjectableMeds=()=>{
    const [injectableInventory,setInjectableInventory] = useState([]);
    const [modalOpen,setModalOpen] = useState(false);
    const [quantity,setQuantity] = useState('');
    const [currentMedicine,setCurrentMedicine] = useState(null);
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
    
    const handleStockUpdate = async (action,)=>{
        if(!quantity || !['add','remove'].includes(action)) return;
        //console.log(currentMedicine,quantity,action);
        try{
            const res = await axios.post('http://localhost:3003/api/med/update', {
                itemName: currentMedicine,
                quantity: quantity, 
                action: action
              });
              setModalOpen(false);
        }catch(error){
            console.log('Error updating data',error);
        }
    }

    const handleOpenModal=(medicine_name)=>{
        setModalOpen(!modalOpen);
        setCurrentMedicine(medicine_name);
    }
    return(
        <>
        <div className="min-h-screen overflow-auto">
        {injectableInventory.map((item,index)=>(
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

                    <div className="">
                        <button onClick={()=>handleOpenModal(item.medicine_name)}>
                            <FontAwesomeIcon icon={faPen} className="view-icon"/>
                        </button>
                        {/* {modalOpen === index && ( */}
                        {/* )} */}
                    </div>
                </div>
            ))}
            {modalOpen && (<div className="modal">
                <div className="modal-content">
                    <div><h3>Update Stock for Item </h3></div>
                        <form onSubmit={(e) => e.preventDefault()}>
                            <input
                                type="number"
                                value={quantity}
                                required
                                onChange={(e)=>setQuantity(e.target.value)}
                                />
                            <button className="submitBtn" type="submit" onClick={()=>handleStockUpdate('add')}>ADD</button>
                        </form >
                        <form onSubmit={(e) => e.preventDefault()}>
                                <input
                                type="number"
                                value={quantity}
                                onChange={(e)=>setQuantity(e.target.value)}
                                required
                                />
                            <button className="removeBtn m-rounded-md" type="submit" onClick={()=>handleStockUpdate('remove')}>REMOVE</button>
                        </form>
                        <div className="manufacturer-details">Manufacturer Details: </div>   
                        <button className="modal-close" onClick={handleOpenModal} >Close</button>
                        </div>
                </div>
            )}

        </div>
        </>
    );
};

export default InjectableMeds;