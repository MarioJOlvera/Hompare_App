
json_url_mun = "https://real-estate-mexico.herokuapp.com/vw_datos_municipio"
json_url_houses = "https://real-estate-mexico.herokuapp.com/house_prices"


d3.json(json_url_houses).then(function (data) {
    function table() {
        let tbody = d3.select("tbody");
        data.forEach(function (record) {
            //console.log(sighteen);
            let row = tbody.append("tr");
            Object.entries(record).forEach(function ([key, value]) {
                //console.log(key, value);
                let cell = row.append("td");
                cell.text(value);
            });
        });
    }

    function search() {
        // Prevent the page from refreshing
        // d3.event.preventDefault();

        //Select the input element, get the raw HTML node and Get the value property of the input elements
        var inputValState = d3.select("#State").property("value");
        let inputValMun = d3.select("#Municipality").property("value");

        if (inputValState == "Ciudad de México") {
            var inputValState = "Distrito Federal"
        } else if (inputValState == "México") {
            var inputValState = "Estado De México"
        }

        console.log(inputValState)

        let filteredTable = data.filter(x =>
            (x.CIUDAD === inputValState || !inputValState) &&
            (x.MUNICIPIO === inputValMun || !inputValMun))


        // If statements according to user input
        if (filteredTable.length === 0) {
            clearBody();
            // If no results found display a message
            d3.select("tbody").html("<h3>No results found</h3>");
        } else {
            clearBody();
            console.log(filteredTable);
            let tbody = d3.select("tbody");
            filteredTable.forEach(function (record) {
                //console.log(sighteen);
                let row = tbody.append("tr");
                Object.entries(record).forEach(function ([key, value]) {
                    //console.log(key, value);
                    let cell = row.append("td");
                    cell.text(value);
                });
            });
        }
    }

    
    function clearInput() {
        //d3.event.preventDefault();
        // Select input fields
        let value = d3.select(".form-group")._groups[0];
        console.log(value);
        // Iterate to obtain input values and set them to be ""
        value.forEach(value => value.value = "");
        // Call function to clear body and display initial data
        clearBody();
        table();
    }
    
    table();
    d3.select("#button").on("click", search)
    d3.select("#buttonClear").on("click", clearInput)

})

function changedropMun() {
    d3.select("#Municipality").html("")
    let dropdownMun = d3.select("#Municipality")
    let dropState = d3.select("#State").property("value")
    dropdownMun.append("option").text("")
    d3.json(json_url_mun).then(function (data) {
        //console.log(data)
        let filteredData = data.filter(x => x.ESTADO == dropState)
        filteredData.forEach(el => {
            //console.log(el.Municipio)
            dropdownMun.append("option").text(el.MUNICIPIO)
        });
    });
}

function clearBody() {
    d3.select("tbody").html("");
};

changedropMun();
d3.select("#State").on("change", changedropMun)
