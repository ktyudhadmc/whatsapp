export function formatPhoneNumber(input: string): string {
  let number = input.replace(/\D/g, "");

  if (!number) {
    throw new Error("Invalid phone number");
  }

  // NORMALISASI PREFIX
  if (number.startsWith("0")) {
    number = "62" + number.slice(1);
  } else if (number.startsWith("8")) {
    number = "62" + number;
  } else if (!number.startsWith("62")) {
    number = "62" + number;
  }

  // VALIDASI PANJANG
  if (number.length < 11 || number.length > 15) {
    throw new Error("Invalid phone number length");
  }

  // VALIDASI FORMAT INDONESIA
  if (!/^62[0-9]{9,13}$/.test(number)) {
    throw new Error("Invalid Indonesian phone number format");
  }

  return number;
}
