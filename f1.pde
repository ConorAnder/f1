color background = color(13, 31, 45);
color primary1 = color(68, 255, 210);
color primary2 = color(238, 108, 77);
color accent = color(255, 221, 74);
color stroke = color(119, 135, 139);

int map_width_left, map_width_right;
int map_height_bottom, map_height_top;

int bar_width_left, bar_width_right;
int bar_height_bottom, bar_height_top;

Table hamilton_dry;
Table hamilton_wet;
Table leclerc_dry;
Table leclerc_wet;
Table tsunoda_dry;
Table tsunoda_wet;
Table russel_dry;
Table russel_wet;
int track_index;

void settings() {
    // int page_height = 1000;
    // size(int(sqrt(2) * page_height), page_height);
    fullScreen();
}

void setup() {
    background(background);
    hamilton_dry = loadTable("hamilton_dry.csv", "header");
    hamilton_wet = loadTable("hamilton_wet.csv", "header");
    leclerc_dry = loadTable("leclerc_dry.csv", "header");
    leclerc_wet = loadTable("leclerc_wet.csv", "header");
    tsunoda_dry = loadTable("tsunoda_dry.csv", "header");
    tsunoda_wet = loadTable("tsunoda_wet.csv", "header");
    russel_dry = loadTable("russel_dry.csv", "header");
    russel_wet = loadTable("russel_wet.csv", "header");

    map_width_left = 100; map_width_right = 2 * width / 3;
    map_height_bottom = 7 * height / 12 - 50; map_height_top = 50;

    bar_width_left = map_width_left; bar_width_right = width / 2 + bar_width_left;
    bar_height_bottom = height - map_height_top; bar_height_top = map_height_bottom + map_height_top;

    track_index = 0;
    //plotMap(hamilton_dry, hamilton_dry.getRowCount());
    rectMode(CORNERS);
    rect(bar_width_left, bar_height_top, bar_width_right, bar_height_bottom);
}

void draw() {
    int size = hamilton_dry.getRowCount();
    if(plotPath(hamilton_wet, size)) {
        noLoop();
    }
}