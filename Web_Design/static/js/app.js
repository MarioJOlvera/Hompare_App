
json_mun = "https://real-estate-mexico.herokuapp.com/vw_datos_municipio"
json_state = "https://real-estate-mexico.herokuapp.com/vw_datos_estado"

const round = (number, decimalPlaces) => {
  const factorOfTen = Math.pow(10, decimalPlaces)
  return Math.round(number * factorOfTen) / factorOfTen
}


function changedropMun() {
  d3.select("#Municipality1").html("")
  let dropdownMun = d3.select("#Municipality1")
  let dropState = d3.select("#State1").property("value")
  dropdownMun.append("option").text("All")
  d3.json(json_mun).then(function (data) {
    //console.log(data)
    let filteredData = data.filter(x => x.ESTADO == dropState)
    filteredData.forEach(el => {
      //console.log(el.Municipio)
      dropdownMun.append("option").text(el.MUNICIPIO)
    });
  });
}

function changedropMun2() {

  d3.select("#Municipality2").html("")
  let dropdownMun = d3.select("#Municipality2")
  let dropState = d3.select("#State2").property("value")
  dropdownMun.append("option").text("All")
  d3.json(json_mun).then(function (data) {
    //console.log(data)
    let filteredData = data.filter(x => x.ESTADO == dropState)
    filteredData.forEach(el => {
      //console.log(el.Municipio)
      dropdownMun.append("option").text(el.MUNICIPIO)
    });
  });
}
// Bar
function barLeft1() {

  let valEst = d3.select("#State1").property("value");
  let valMun = d3.select("#Municipality1").property("value");

  // console.log(valEst);
  // console.log(valMun);

  let layout1 = {
    autosize: false,
    title: 'Development Indexes',
    font: {
      family: 'Raleway, sans-serif',
      size: 12
    },
    xaxis: {
      showticklabels: true,
      showgrid: true,
      tickangle: -45
    },
    height: 500,
    width: 400,
    margin: {
      t: 50,
      r: 0,
      l: 120,
      pad: 4
    }
  }
  // Responsiveness from the chart
  let config = { responsive: true };

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      console.log(filteredData)

      let stats = [];
      let labels = ["Education", "Health", "Income", "HDI"];
      filteredData.forEach(el => {
        stats.push(round(el.PROM_INDICE_EDUCACION, 3), round(el.PROM_INDICE_SALUD, 3), round(el.PROM_INDICE_INGRESO, 3), round(el.PROM_IDH, 3))
      });

      console.log(stats)
      // Define trace
      let trace1 = {
        x: stats,
        y: labels,
        type: 'bar',
        marker: {
          color: '#027bce',
        },
        orientation: 'h'
        //text: 
      }
      //Define data
      let plotData = [trace1];

      //Define layout

      // Display chart
      Plotly.newPlot("bar", plotData, layout1, config);

    })

  } else {

    d3.json(json_state).then(function (data) {
      //console.log(data)

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)

      let stats = [];
      let labels = ["Education", "Health", "Income", "HDI"];
      filteredData.forEach(el => {
        stats.push(round(el.PROM_INDICE_EDUCACION, 3), round(el.PROM_INDICE_SALUD, 3), round(el.PROM_INDICE_INGRESO, 3), round(el.PROM_IDH, 3))
      });
      //console.log(stats);

      // Define trace
      let trace1 = {
        x: stats,
        y: labels,
        type: 'bar',
        marker: {
          color: '#027bce',
        },
        orientation: 'h'
        //text: 
      }
      //Define data
      let plotData = [trace1];

      // Display chart
      Plotly.newPlot("bar", plotData, layout1, config);

    })
  }

}

function gaugesLeft1() {

  let valEst = d3.select("#State1").property("value");
  let valMun = d3.select("#Municipality1").property("value");

  console.log(valEst)

  let layout2 = {
    autosize: false,
    width: 350,
    height: 350,
    margin: { t: 25, r: 10, l: 165, b: 25 },
  };

  let config = { responsive: true }

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      console.log(filteredData)
      let valcount = filteredData[0].NO_INMUEBLES
      let valprice = filteredData[0].PROM_PRECIO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: valcount,
          title: {
            text:
              "No. of properties<br>offered"
          },
          domain: { x: [0, 0.85], y: [0, 0.5] },
          //delta: { reference: 50, position: "left" }
        },
        {
          type: "indicator",
          mode: "number",
          value: valprice,
          number: { prefix: "$" },
          title: {
            text:
              "Average Price"
          },
          //delta: { reference: 50, position: "left" },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]

      // Display chart
      Plotly.newPlot("gauge", plotData2, layout2, config);

    })


  } else {

    d3.json(json_state).then(function (data) {

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)
      let valcount = filteredData[0].NO_INMUEBLES
      let valprice = filteredData[0].PROM_PRECIO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: valcount,
          title: {
            text:
              "No. of properties<br>offered"
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: valprice,
          number: { prefix: "$" },
          title: {
            text:
              "Average Price"
          },
          delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]
      // Display chart
      Plotly.newPlot("gauge", plotData2, layout2, config);
    })
  }
};

function gaugesLeft2() {

  let valEst = d3.select("#State1").property("value");
  let valMun = d3.select("#Municipality1").property("value");

  let layout2 = {
    autosize: false,
    width: 350,
    height: 350,
    margin: { t: 25, r: 10, l: 165, b: 25 }
  };

  let config = { responsive: true }

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      //console.log(filteredData)

      let val_constr = filteredData[0].PROM_CONSTRUCCION
      let val_terreno = filteredData[0].PROM_TERRENO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: val_constr,
          number: { suffix: "  m2" },
          title: {
            text:
              "Avg built<br>surface "
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: val_terreno,
          number: { suffix: "  m2" },
          title: {
            text:
            "Avg total<br>surface " 
          },
          // delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]

      // Display chart
      Plotly.newPlot("gauge2L", plotData2, layout2, config);

    })


  } else {

    d3.json(json_state).then(function (data) {

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)
      let val_constr = filteredData[0].PROM_CONSTRUCCION
      let val_terreno = filteredData[0].PROM_TERRENO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: val_constr,
          number: { suffix: "  m2" },
          title: {
            text:
              "Avg built<br>surface "
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: val_terreno,
          number: { suffix: "  m2" },
          title: {
            text:
              "Avg total<br>surface "
          },
          delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]
      // Display chart
      Plotly.newPlot("gauge2L", plotData2, layout2, config);
    })
  }
};

function gaugesLeft3() {

  let valEst = d3.select("#State1").property("value");
  let valMun = d3.select("#Municipality1").property("value");

  let layout2 = {
    autosize: false,
    width: 400,
    height: 290,
    margin: { t: 0, r: 50, l: 125, b: 0 }
  };

  let config = { responsive: true }

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      //console.log(filteredData)

      let val_recamaras = filteredData[0].PROM_RECAMARAS
      let plotData2 = [
        {
          type: "indicator",
          mode: "gauge+number",
          value: Math.round(val_recamaras),
          title: {
            text:
              "Avg No.<br>of bedrooms"
          },
          domain: { x: [0, 1], y: [0, 1] },
          gauge: {
            axis: {
              range: [null, 6]
            },
            steps: [
              { range: [0, 1], color: "#04e824" },
              { range: [1, 2], color: "yellow" },
              { range: [2, 3], color: "#f5bb00" },
              { range: [3, 4], color: "#ec9f05" },
              { range: [4, 5], color: "#e24e1b" },
              { range: [5, 6], color: "red" },
            ],
            bar: { color: "black" }
          }
        }
      ]

      // Display chart
      Plotly.newPlot("gauge3L", plotData2, layout2, config);

    })


  } else {

    d3.json(json_state).then(function (data) {

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)
      let val_recamaras = filteredData[0].PROM_RECAMARAS

      let plotData2 = [
        {
          type: "indicator",
          mode: "gauge+number",
          value: Math.round(val_recamaras),
          title: {
            text:
              "Avg No.<br>of bedrooms"
          },
          domain: { x: [0, 1], y: [0, 1] },
          gauge: {
            axis: {
              range: [null, 6]
            },
            steps: [
              { range: [0, 1], color: "#04e824" },
              { range: [1, 2], color: "yellow" },
              { range: [2, 3], color: "#f5bb00" },
              { range: [3, 4], color: "#ec9f05" },
              { range: [4, 5], color: "#e24e1b" },
              { range: [5, 6], color: "red" },
            ],
            bar: { color: "black" }
          }
        }
      ]
      // Display chart
      Plotly.newPlot("gauge3L", plotData2, layout2, config);
    })
  }
};


function callSeveral() {
  changedropMun();
  barLeft1();
  gaugesLeft1();
  gaugesLeft2();
  gaugesLeft3();
}

function graphs() {
  barLeft1();
  gaugesLeft1();
  gaugesLeft2();
  gaugesLeft3();
}

//////------------------------------------------------------ Right side
// Bar
function barRight() {

  let valEst = d3.select("#State2").property("value");
  let valMun = d3.select("#Municipality2").property("value");

  //console.log(valEst);
  //console.log(valMun);

  let layout1 = {
    autosize: false,
    title: 'Development Indexes',
    font: {
      family: 'Raleway, sans-serif',
      size: 12
    },
    xaxis: {
      showticklabels: true,
      showgrid: true,
      tickangle: -45
    },
    height: 500,
    width: 400,
    margin: {
      t: 50,
      r: 0,
      l: 140,
      pad: 4
    }
  }
  // Responsiveness from the chart
  let config = { responsive: true };

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      //console.log(filteredData)

      let stats = [];
      let labels = ["Education", "Health", "Income", "HDI"];
      filteredData.forEach(el => {
        stats.push(round(el.PROM_INDICE_EDUCACION, 3), round(el.PROM_INDICE_SALUD, 3), round(el.PROM_INDICE_INGRESO, 3), round(el.PROM_IDH, 3))
      });

      // Define trace
      let trace1 = {
        x: stats,
        y: labels,
        marker: { color: "red" },
        type: 'bar',
        orientation: 'h'
        //text: 
      }
      //Define data
      let plotData = [trace1];

      //Define layout

      // Display chart
      Plotly.newPlot("bar2", plotData, layout1, config);

    })

  } else {

    d3.json(json_state).then(function (data) {
      console.log(data)

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)

      let stats = [];
      let labels = ["Education", "Health", "Income", "HDI"];
      filteredData.forEach(el => {
        stats.push(round(el.PROM_INDICE_EDUCACION, 3), round(el.PROM_INDICE_SALUD, 3), round(el.PROM_INDICE_INGRESO, 3), round(el.PROM_IDH, 3))
      });
      //console.log(stats);

      // Define trace
      let trace1 = {
        x: stats,
        y: labels,
        type: 'bar',
        marker: {
          color: 'red',
        },
        orientation: 'h'
        //text: 
      }
      //Define data
      let plotData = [trace1];

      // Display chart
      Plotly.newPlot("bar2", plotData, layout1, config);

    })
  }

}

function gaugesRight1() {

  let valEst = d3.select("#State2").property("value");
  let valMun = d3.select("#Municipality2").property("value");

  let layout2 = {
    autosize: false,
    width: 350,
    height: 350,
    margin: { t: 25, r: 10, l: 165, b: 25 }
  };

  // Responsiveness from the chart
  let config = { responsive: true };

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      console.log(filteredData)
      let valcount = filteredData[0].NO_INMUEBLES
      let valprice = filteredData[0].PROM_PRECIO


      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: valcount,
          title: {
            text:
              "No. of properties<br>offered"
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: valprice,
          number: { prefix: "$" },
          title: {
            text:
              "Average Price"
          },
          delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]

      // Display chart
      Plotly.newPlot("gauge1R", plotData2, layout2, config);

    })


  } else {

    d3.json(json_state).then(function (data) {

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)
      let valcount = filteredData[0].NO_INMUEBLES
      let valprice = filteredData[0].PROM_PRECIO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: valcount,
          title: {
            text:
              "No. of properties<br>offered"
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: valprice,
          number: { prefix: "$" },
          title: {
            text:
              "Average Price"
          },
          delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]
      // Display chart
      Plotly.newPlot("gauge1R", plotData2, layout2, config);
    })
  }
};

function gaugesRight2() {

  let valEst = d3.select("#State2").property("value");
  let valMun = d3.select("#Municipality2").property("value");

  let layout2 = {
    autosize: false,
    width: 350,
    height: 350,
    margin: { t: 25, r: 10, l: 165, b: 25 }
  };

  let config = { responsive: true }

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      console.log(filteredData)

      let val_constr = filteredData[0].PROM_CONSTRUCCION
      let val_terreno = filteredData[0].PROM_TERRENO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          value: val_constr,
          number: { suffix: "  m2" },
          title: {
            text:
              "Avg built<br>surface m2"
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: val_terreno,
          number: { suffix: "  m2" },
          title: {
            text:
            "Avg total<br>surface " 
          },
          // delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]

      // Display chart
      Plotly.newPlot("gauge2R", plotData2, layout2, config);

    })
  } else {
    d3.json(json_state).then(function (data) {

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)
      let val_constr = filteredData[0].PROM_CONSTRUCCION
      let val_terreno = filteredData[0].PROM_TERRENO

      let plotData2 = [
        {
          type: "indicator",
          mode: "number",
          number: { suffix: "  m2" },
          value: val_constr,
          title: {
            text:
              "Avg built<br>surface "
          },
          domain: { x: [0, 0.85], y: [0, 0.5] }
          //delta: { reference: 400, relative: true, position: "top" }
        },
        {
          type: "indicator",
          mode: "number",
          value: val_terreno,
          number: { suffix: "  m2" },
          title: {
            text:
              "Avg total<br>surface " 
          },
          delta: { relative: true },
          domain: { x: [0, 0.85], y: [0.5, 1] }
        }
      ]
      // Display chart
      Plotly.newPlot("gauge2R", plotData2, layout2, config);
    })
  }
};

function gaugesRight3() {

  let valEst = d3.select("#State2").property("value");
  let valMun = d3.select("#Municipality2").property("value");

  let layout2 = {
    autosize: false,
    width: 400,
    height: 290,
    margin: { t: 0, r: 50, l: 125, b: 0 }
  };

  let config = { responsive: true }

  if (valMun != "All") {
    d3.json(json_mun).then(function (data) {

      let filteredData = data.filter(x => x.MUNICIPIO == valMun)
      //console.log(filteredData)

      let val_recamaras = filteredData[0].PROM_RECAMARAS
      let plotData2 = [
        {
          type: "indicator",
          mode: "gauge+number",
          value: Math.round(val_recamaras),
          title: {
            text:
              "Avg No.<br>of bedrooms"
          },
          domain: { x: [0, 1], y: [0, 1] },
          gauge: {
            axis: {
              range: [null, 6]
            },
            steps: [
              { range: [0, 1], color: "#04e824" },
              { range: [1, 2], color: "yellow" },
              { range: [2, 3], color: "#f5bb00" },
              { range: [3, 4], color: "#ec9f05" },
              { range: [4, 5], color: "#e24e1b" },
              { range: [5, 6], color: "red" },
            ],
            bar: { color: "black" }
          }
        }
      ]

      // Display chart
      Plotly.newPlot("gauge3R", plotData2, layout2, config);

    })

  } else {

    d3.json(json_state).then(function (data) {

      let filteredData = data.filter(x => x.ESTADO == valEst)
      //console.log(filteredData)
      let val_recamaras = filteredData[0].PROM_RECAMARAS

      let plotData2 = [
        {
          type: "indicator",
          mode: "gauge+number",
          value: Math.round(val_recamaras),
          title: {
            text:
              "Avg No.<br>of bedrooms"
          },
          domain: { x: [0, 1], y: [0, 1] },
          gauge: {
            axis: {
              range: [null, 6]
            },
            steps: [
              { range: [0, 1], color: "#04e824" },
              { range: [1, 2], color: "yellow" },
              { range: [2, 3], color: "#f5bb00" },
              { range: [3, 4], color: "#ec9f05" },
              { range: [4, 5], color: "#e24e1b" },
              { range: [5, 6], color: "red" },
            ],
            bar: { color: "black" }
          }
        }
      ]
      // Display chart
      Plotly.newPlot("gauge3R", plotData2, layout2, config);
    })
  }
};

function callSeveral2() {
  changedropMun2();
  barRight();
  gaugesRight1();
  gaugesRight2();
  gaugesRight3();
}

function graphs2() {
  barRight();
  gaugesRight1();
  gaugesRight2();
  gaugesRight3();
}


///////-----------------------------------------------------------------

d3.select("#State1").on("change", callSeveral)
d3.select("#Municipality1").on("change", graphs)

d3.select("#State2").on("change", callSeveral2)
d3.select("#Municipality2").on("change", graphs2)

changedropMun();
changedropMun2();

graphs();
graphs2();

