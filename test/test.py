# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
import hashlib
import random

# List of predefined words
words = [
    "Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
    "Integer", "nec", "odio", "Praesent", "libero", "Sed", "cursus", "ante",
    "dapibus", "diam", "Sed", "nisi", "Nulla", "quis", "sem", "at", "nibh",
    "elementum", "imperdiet", "Duis", "sagittis", "ipsum", "Praesent", "mauris",
    "Fusce", "nec", "tellus", "sed", "augue", "semper", "porta", "Mauris",
    "massa", "Vestibulum", "lacinia", "arcu", "eget", "nulla", "Class", "aptent",
    "taciti", "sociosqu", "ad", "litora", "torquent", "per", "conubia", "nostra",
    "per", "inceptos", "himenaeos", "Curabitur", "sodales", "ligula", "in",
    "libero", "Sed", "dignissim", "lacinia", "nunc"
]

def generate_sentence(min_words=6, max_words=15):
    # Generate a random sentence with a random number of words
    sentence_length = random.randint(min_words, max_words)
    sentence = ' '.join(random.choices(words, k=sentence_length))
    return sentence.capitalize() + '.'

def generate_paragraph(num_sentences=5):
    # Generate a paragraph with a specified number of sentences
    paragraph = ' '.join(generate_sentence() for _ in range(num_sentences))
    return paragraph

def generate_random_paragraphs(num_paragraphs=5, num_sentences_per_paragraph=5):
    paragraphs = [generate_paragraph(num_sentences_per_paragraph) for _ in range(num_paragraphs)]
    return '\n\n'.join(paragraphs)


# SHA-256 constants (first 32 bits of the fractional parts of the cube roots of the first 64 primes)
K = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b,
    0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01,
    0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7,
    0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152,
    0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
    0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc,
    0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819,
    0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08,
    0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f,
    0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
]

# Right rotate function
def right_rotate(value, shift):
    return (value >> shift) | (value << (32 - shift)) & 0xFFFFFFFF

# SHA-256 functions
def ch(x, y, z):
    return (x & y) ^ (~x & z)

def maj(x, y, z):
    return (x & y) ^ (x & z) ^ (y & z)

def sigma0(x):
    return right_rotate(x, 2) ^ right_rotate(x, 13) ^ right_rotate(x, 22)

def sigma1(x):
    return right_rotate(x, 6) ^ right_rotate(x, 11) ^ right_rotate(x, 25)

def gamma0(x):
    return right_rotate(x, 7) ^ right_rotate(x, 18) ^ (x >> 3)

def gamma1(x):
    return right_rotate(x, 17) ^ right_rotate(x, 19) ^ (x >> 10)

# Initialize hash values (first 32 bits of the fractional parts of the square roots of the first 8 primes)
H = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
]

def pad_message(message):
    # Convert message to bytes
    message_bytes = message.encode('utf-8')

    # Calculate the length of the message in bits
    message_len_bits = len(message_bytes) * 8

    # Append the bit '1' to the message
    padded_message = message_bytes + b'\x80'

    # Append k bits '0', where k is the minimum number >= 0 such that the length of the message + 1 + k + 64 is a multiple of 512
    while (len(padded_message) * 8 + 64) % 512 != 0:
        padded_message += b'\x00'

    # Append the length of the message as a 64-bit big-endian integer
    padded_message += message_len_bits.to_bytes(8, byteorder='big')

    return padded_message
    
def int_to_6bit_string(value):
    if value < 0 or value > 63:
        raise ValueError("Value must be between 0 and 63 inclusive for 6-bit representation.")
    return f"{value:06b}"

def concatenate_bits(two_bits, six_bits):
    if two_bits < 0 or two_bits > 3:
        raise ValueError("Two-bit value must be between 0 and 3 inclusive.")
    if six_bits < 0 or six_bits > 63:
        raise ValueError("Six-bit value must be between 0 and 63 inclusive.")
    
    # Convert to binary strings
    two_bit_str = f"{two_bits:02b}"
    six_bit_str = f"{six_bits:06b}"
    
    # Concatenate the binary strings
    eight_bit_str = two_bit_str + six_bit_str
    
    # Convert the concatenated binary string to an integer
    return int(eight_bit_str, 2)
# Process a single 512-bit block
def process_block(block):
    w = [0] * 64
    for i in range(16):
        w[i] = int.from_bytes(block[i*4:(i*4)+4], 'big')
    for i in range(16, 64):
        w[i] = (gamma1(w[i-2]) + w[i-7] + gamma0(w[i-15]) + w[i-16]) & 0xFFFFFFFF

    a, b, c, d, e, f, g, h = H

    for t in range(64):
        t1 = (h + sigma1(e) + ch(e, f, g) + K[t] + w[t]) & 0xFFFFFFFF
        t2 = (sigma0(a) + maj(a, b, c)) & 0xFFFFFFFF
        #print(f"Round {t+1:2d} : w={w[t]:08x}, k={K[t]:08x} , w+k = {w[t] + K[t] :08x} , ch = {ch(e,f,g) : 08x} , maj = {maj(a,b,c) : 08x} , sig0={sigma0(a) :08x} , sig1= {sigma1(e):08x},T1 = {t1 : 08x} , T2 = {t2:08x}")
        #print(f"Round {t+1:2d} : w+k+h + ch = {w[t] + K[t] + h +  ch(e, f, g) : 08x} ")
        h = g
        g = f
        f = e
        e = (d + t1) & 0xFFFFFFFF
        d = c
        c = b
        b = a
        a = (t1 + t2) & 0xFFFFFFFF
        #print(f"Round {t+1:2d}: a={a:08x}, b={b:08x}, c={c:08x}, d={d:08x}, e={e:08x}, f={f:08x}, g={g:08x}, h={h:08x}")

    H[0] = (H[0] + a) & 0xFFFFFFFF
    H[1] = (H[1] + b) & 0xFFFFFFFF
    H[2] = (H[2] + c) & 0xFFFFFFFF
    H[3] = (H[3] + d) & 0xFFFFFFFF
    H[4] = (H[4] + e) & 0xFFFFFFFF
    H[5] = (H[5] + f) & 0xFFFFFFFF
    H[6] = (H[6] + g) & 0xFFFFFFFF
    H[7] = (H[7] + h) & 0xFFFFFFFF

def sha256(message):
    message = pad_message(message)
    for i in range(0, len(message), 64):
        process_block(message[i:i+64])
    return ''.join(f'{h:08x}' for h in H)


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    num_paragraphs = 1  # Change this to generate more or fewer paragraphs
    num_sentences_per_paragraph = 10  # Change this to control the length of each paragraph
    message = generate_random_paragraphs(num_paragraphs, num_sentences_per_paragraph)
    padded_message = pad_message(message)
    exp_sha_output = sha256(message)

    # Split the padded message into 512-bit (64-byte) chunks
    chunks = [padded_message[i:i+64] for i in range(0, len(padded_message), 64)]

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut._log.info("Test project behavior")
    

    # Print each 512-bit input chunk
    for i, chunk in enumerate(chunks):
        #print(f"Chunk {i+1} (512 bits): {chunk.hex()}")
        #print(f"{chunk[0]}")
        for j, chun in enumerate(chunk):
            await ClockCycles(dut.clk, 10)
            dut.uio_in.value[7] = 0x0
            dut.uio_in.value[6] = 0x1
            addr = 63 - j
            data = chun[addr] 
            dut.uio_in.value[5:0] = j
            dut.ui_in.value = data
            await ClockCycles(dut.clk, 10)
        dut.uio_in.value[6] = 0x0 
        dut.uio_in.value[5:0] = 0x0
        await ClockCycles(dut.clk, 10)    
        while not dut.uio_out.value[7] :
            await ClockCycles(dut.clk, 10)
        
    
    hash_out = []
    for k in range(32):
        dut.uio_in.value[4:0] = k
        hash_out.append(dut.uo_out.value.integer)
        await ClockCycles(dut.clk, 10)
    # Set the input values you want to test
    #dut.ui_in.value = 20
    #dut.uio_in.value = 30
    hash_out_str = ''.join(f'{byte:02x}' for byte in hash_out)

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert hash_out_str == exp_sha_output

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
