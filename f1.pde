color background = color(15, 15, 20);
color primary1 = color(255, 40, 0);
color primary2 = color(0, 255, 100);
color accent = color(255, 140, 0);
color stroke = color(255, 255, 255);

Table hamilton_dry;
Table hamilton_wet;
Table leclerc_dry;
Table leclerc_wet;
Table tsunoda_dry;
Table tsunoda_wet;
int track_index;

void settings() {
    int page_height = 1000;
    size(int(sqrt(2) * page_height), page_height);
}

void setup() {
    background(background);
    hamilton_dry = loadTable("hamilton_dry.csv", "header");
    hamilton_wet = loadTable("hamilton_wet.csv", "header");
    leclerc_dry = loadTable("leclerc_dry.csv", "header");
    leclerc_wet = loadTable("leclerc_wet.csv", "header");
    tsunoda_dry = loadTable("tsunoda_dry.csv", "header");
    tsunoda_wet = loadTable("tsunoda_wet.csv", "header");

    track_index = 0;
}

void draw() {
    int size = hamilton_dry.getRowCount();
    
}