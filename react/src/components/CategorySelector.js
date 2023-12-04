import AsyncSelect from 'react-select/async';
import React, {useState, useEffect} from 'react'

export default function CategorySelector({changeHandler, label}) {

    const [allCategories, setAllCategories] = useState()

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    const findCategories = (inputValue, callback) => {
        console.log("Fetching categories like "+inputValue)
        fetch(buildUrlForInputValue(inputValue))
            .then(res => res.json())
            .then(
                json => callback(convertToLinkedCategoriesIfNecessary(json)))
    }

    function convertToLinkedCategoriesIfNecessary(json) {
        if(json._embedded) {
            mapCategoriesArray(json._embedded.categories)
            return json._embedded.categories.map(c => ({ value: c._links.self.href, label: c.name }))
        }
        else {
            return json.map( c => 
                (
                    {value: allCategories[c.id].value, label: allCategories[c.id].name }))
        }
    }

    function mapCategoriesArray(catArr) {
        const map = {}
        catArr.forEach( c => 
            map[parseId(c)] = {value: c._links.self.href, name: c.name})
        setAllCategories(map)
    }

    function buildUrlForInputValue(inputValue) {
        if(inputValue) {
            return "http://localhost:8080/categories/search/findByNameContainsIgnoreCase?name="+inputValue
        }
        else return "http://localhost:8080/categories";
    }

    return (
        <div className="w-full px-3 mb-6 md:mb-0">
            <label className="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" htmlFor="grid-name">
                {label}
            </label>
            <AsyncSelect
                onChange={changeHandler}
                defaultOptions
                cacheOptions
                closeMenuOnSelect={false}
                isMulti
                loadOptions={findCategories}
                loadingMessage={() => console.log("Loading")}
             />
        </div>
    );
}