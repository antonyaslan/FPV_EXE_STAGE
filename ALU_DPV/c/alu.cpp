#include "Hector.h"
#include <stdint.h>

void performAnd(int32_t operand1, uint32_t operand2, uint32_t &result) {
  result = operand1 & operand2;
}
void performOr(uint32_t operand1, uint32_t operand2, uint32_t &result) {
  result = operand1 | operand2;
}
void performAdd(uint32_t operand1, uint32_t operand2, uint32_t &result) {
  int32_t operand1_32bit, operand2_32bit, result_32bit;
  operand1_32bit = static_cast<int32_t> (operand1);
  operand2_32bit = static_cast<int32_t> (operand2);

  result_32bit = operand1_32bit + operand2_32bit;
  result = static_cast <uint32_t> (result_32bit);
}
void performSub(uint32_t operand1, uint32_t operand2, uint32_t &result) {
  int32_t operand1_32bit, operand2_32bit, result_32bit;
  operand1_32bit = static_cast<int32_t> (operand1);
  operand2_32bit = static_cast<int32_t> (operand2);

  result_32bit = operand1_32bit - operand2_32bit;
    result = static_cast <uint32_t> (result_32bit);
}
void performSatAdd(uint32_t operand1, uint32_t operand2, uint32_t &result) {
    result = static_cast <uint64_t> (operand1) + operand2;
}
void performSatSub(uint32_t operand1, uint32_t operand2, uint32_t &result) {
    result = static_cast <uint64_t> (operand1) - operand2;
}

// void performMultiply(uint32_t operand1, uint32_t operand2, uint32_t &result) {
    // result = (operand1 & 0xffffffff) * (operand2 & 0xffffffff);
    // result = (operand1 & 0xffff) * (operand2 & 0xffff);
// }

int alu (uint8_t command, uint32_t operand1, uint32_t operand2, uint32_t &result) {

switch(command) {
  case 0: performAnd(operand1, operand2, result);
          break;
  case 1: performOr(operand1, operand2, result);
          break;
  case 2: performAdd(operand1, operand2, result);
          break;
  case 3: performSub(operand1, operand2, result);
          break;
	  //  case 4: performSatAdd(operand1, operand2, result);
          //break;
	  //  case 5: performSatSub(operand1, operand2, result);
          //break;
  // case 6: performMultiply(operand1, operand2, result);
          // break;
}
 return 0;
}

int DPV_wrapper () {
uint32_t operand1;
uint32_t operand2;
uint8_t command;
uint32_t result;
Hector::registerInput ("in_a", operand1);
Hector::registerInput ("in_b", operand2);
Hector::registerInput ("command", command);
Hector::registerOutput ("result", result);

Hector::beginCapture();
  result = 0;
  alu(command, operand1, operand2, result);
Hector::endCapture();
return 0;
}
