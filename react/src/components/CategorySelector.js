
import AsyncSelect from 'react-select/async';
import React, {useState, useEffect} from 'react'

export default function CategorySelector() {
    // const [categories, setCategories] = useState();
    
    // useEffect(
    //     () => {      
    //         fetch("http://localhost:8080/categories")
    //             .then(res => res.json())
    //             .then((json) => {
    //                 const cats = json._embedded.categories.map(c => ({value: c.name, label: c.name}));
    //                 setCategories(cats)
    //                 console.log(JSON.stringify(cats));
    //                 });
            
    //     }, []
    // );
  
    const handleChange = (selectedOption) => {
        console.log("Selected option: "+selectedOption)
    }

    const findCategories = (inputValue, callback) => {
        console.log("FN invoked")
        fetch("http://localhost:8080/categories")
            .then(res => res.json())
            .then(
                json => callback(json._embedded.categories.map(c => ({ value: c.name, label: c.name })))
            )
    }

    return (
        <AsyncSelect
            inputId='categoriesInput'
            onChange={handleChange}
            defaultOptions
            cacheOptions
            closeMenuOnSelect={false}
            isMulti
            loadOptions={findCategories}
            loadingMessage={"Loading categories"}
        />
    );
}