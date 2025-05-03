
function add_legend(map_id, layer_id, legendValues) {

  'use strict';

  var i = 0;

  for (i = 0; i < legendValues.length; i++) {
    if (legendValues[i].type === "category") {
      add_legend_category(map_id, layer_id, legendValues[i]);
    } else {
      if (legendValues[i].legend.colour.length === 1) {
        add_legend_category(map_id, layer_id, legendValues[i]);
      } else {
        add_legend_gradient(map_id, layer_id, legendValues[i]);
      }
    }
  }
}

function add_legend_gradient(map_id, layer_id, legendValues) {
    // fill gradient
    'use strict';
    var legendContent,
        legendTitle,
        tickContainer,
        labelContainer = document.createElement("div"),
        legendColours = document.createElement('div'),
        jsColours = [],
        colours = '',
        i = 0,
        legendTextColour = '#828282',
        style = '',
        isUpdating = false;


    if (window[map_id + 'legend' + layer_id + legendValues.colourType] == null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType] = document.createElement("div");
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('id', map_id + 'legend' + layer_id + legendValues.colourType);
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('class', 'legend');
    }  else {
        isUpdating = true;

        while (window[map_id + 'legend' + layer_id + legendValues.colourType].hasChildNodes()) {
            window[map_id + 'legend' + layer_id + legendValues.colourType].removeChild(window[map_id + 'legend' + layer_id + legendValues.colourType].lastChild);
        }
    }

    legendContent = document.createElement("div"),
    legendTitle = document.createElement("div"),
    tickContainer = document.createElement("div"),
    labelContainer = document.createElement("div"),
    legendColours = document.createElement('div'),

    legendContent.setAttribute('class', 'legendContent');

    legendTitle.setAttribute('class', 'legendTitle');
    legendTitle.innerHTML = legendValues.title;
    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendTitle);

    tickContainer.setAttribute('class', 'tickContainer');
    labelContainer.setAttribute('class', 'labelContainer');

    if (legendValues.css !== null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('style', legendValues.css);
    }

    for (i = 0; i < legendValues.legend.colour.length; i++) {
        jsColours.push(legendValues.legend.colour[i]);
    }

    colours = '(' + jsColours.join() + ')';

    style = 'display: inline-block; height: ' + jsColours.length * 20 + 'px; width: 15px;';
    style += 'background: ' + jsColours[1] + ';';
    style += 'background: -webkit-linear-gradient' + colours + ';';
    style += 'background: -o-linear-gradient' + colours + ';';
    style += 'background: -moz-linear-gradient' + colours + ';';
    style += 'background: linear-gradient' + colours + ';';

    legendColours.setAttribute('style', style);
    legendContent.appendChild(legendColours);

    for (i = 0; i < legendValues.legend.colour.length; i++) {

        var legendValue = 'text-align: left; color: ' + legendTextColour + '; font-size: 12px; height: 20px;',
            divTicks = document.createElement('div'),
            divVal = document.createElement('div');

        divTicks.setAttribute('style', legendValue);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', legendValue);
        divVal.innerHTML = legendValues.legend.variable[i];
        labelContainer.appendChild(divVal);
    }

    legendContent.appendChild(tickContainer);
    legendContent.appendChild(labelContainer);

    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendContent);

    if (isUpdating === false) {
        placeControl(map_id, window[map_id + 'legend' + layer_id + legendValues.colourType], legendValues.position);
    }
}

function generateColourBox(colourType, colour) {
    'use strict';

    if (colourType === "fill_colour") {
        return ('height: 20px; width: 15px; background: ' + colour);
    } else {
        // http://jsfiddle.net/UES6U/2/
        return ('height: 20px; width: 15px; background: linear-gradient(to bottom, white 25%, ' + colour + ' 25%, ' + colour + ' 45%, ' + 'white 45%)');
    }
}

function add_legend_category(map_id, layer_id, legendValues) {

    'use strict';

    var legendContent,
        legendTitle,
        colourContainer,
        tickContainer,
        labelContainer,
        legendColours,
        colourBox = '',
        //colourAttribute = '',
        i = 0,
        legendTextColour = '#828282',
        isUpdating = false;

    // catch undefined OR null
    // https://stackoverflow.com/questions/2647867/how-to-determine-if-variable-is-undefined-or-null
    if (window[map_id + 'legend' + layer_id + legendValues.colourType] == null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType] = document.createElement("div");
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('id', map_id + 'legend' + layer_id + legendValues.colourType);
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('class', 'legend');

    } else {
        isUpdating = true;

        while (window[map_id + 'legend' + layer_id + legendValues.colourType].hasChildNodes()) {
            window[map_id + 'legend' + layer_id + legendValues.colourType].removeChild(window[map_id + 'legend' + layer_id + legendValues.colourType].lastChild);
        }
    }

    legendContent = document.createElement("div");
    legendTitle = document.createElement("div");
    colourContainer = document.createElement("div");
    tickContainer = document.createElement("div");
    labelContainer = document.createElement("div");
    legendColours = document.createElement('div');

    legendContent.setAttribute('class', 'legendContent');
    legendContent.setAttribute('id', 'legendContentId' + map_id + layer_id);

    legendTitle.setAttribute('class', 'legendTitle');
    legendTitle.innerHTML = legendValues.title;
    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendTitle);

    colourContainer.setAttribute('class', 'labelContainer');
    colourContainer.setAttribute('id', 'colourContainerId' + map_id + layer_id);

    tickContainer.setAttribute('class', 'tickContainer');
    tickContainer.setAttribute('id', 'tickContainerId' + map_id + layer_id);

    labelContainer.setAttribute('class', 'labelContainer');
    labelContainer.setAttribute('id', 'labelContainerId' + map_id + layer_id);

    if (legendValues.css !== null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('style', legendValues.css);
    }

    for (i = 0; i < legendValues.legend.colour.length; i++) {

        var tickVal = 'text-left: center; color: ' + legendTextColour + '; font-size: 12px; height: 20px;',
            divCol = document.createElement('div'),
            divTicks = document.createElement('div'),
            divVal = document.createElement('div');

        //colourBox = 'height: 20px; width: 15px; background: ' + legendValues.legend.colour[i];
        colourBox = generateColourBox(legendValues.colourType, legendValues.legend.colour[i]);
        divCol.setAttribute('style', colourBox);
        colourContainer.appendChild(divCol);

        divTicks.setAttribute('style', tickVal);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', tickVal);
        divVal.innerHTML = legendValues.legend.variable[i];
        labelContainer.appendChild(divVal);
    }

    legendContent.appendChild(colourContainer);
    legendContent.appendChild(tickContainer);
    legendContent.appendChild(labelContainer);

    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendContent);

    if (isUpdating === false) {
        placeControl(map_id, window[map_id + 'legend' + layer_id + legendValues.colourType], legendValues.position);
    }

}


function clear_legend(map_id, layer_id){

    // find reference to this layer in the legends
    var id = map_id + 'legend' + layer_id + 'fill_colour';
    var objIndex = findById(window[map_id + 'legendPositions'], id, "index" );

    if(objIndex != null) {
        removeControl(map_id, id, window[map_id + 'legendPositions'][objIndex].position);
        window[map_id + 'legendPositions'].splice(objIndex, 1);
        window[id] = null;
    }

    id = map_id + 'legend' + layer_id + 'stroke_colour';
    objIndex = findById(window[map_id + 'legendPositions'], id, "index" );

    if(objIndex != null) {
        removeControl(map_id, id, window[map_id + 'legendPositions'][objIndex].position);
        window[map_id + 'legendPositions'].splice(objIndex, 1);
        window[id] = null;
    }
}

