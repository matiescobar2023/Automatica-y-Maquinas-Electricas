// the setup function runs once when you press reset or power the board
char dato = '\0';
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
  digitalWrite(LED_BUILTIN, LOW);   // turn the LED on (HIGH is the voltage level)
}

// the loop function runs over and over again forever
void loop() {
  if (Serial.available() > 0){
    dato = Serial.read();
    if (dato == 'a'){
      digitalWrite(LED_BUILTIN, HIGH);    // turn the LED off by making the voltage LOW
    }
    delay(1000);                       // wait for a second
    digitalWrite(LED_BUILTIN, LOW);
  }
}
