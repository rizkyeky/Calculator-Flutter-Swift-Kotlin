package com.rizkyeky.calculator

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import android.widget.Button
import com.rizkyeky.calculator.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    private var mainDisplay: String = ""

    private var mainNumbers: MutableList<Int?> = mutableListOf(null)
    private var mainOpers: MutableList<Char?> = mutableListOf(null)

    private var currIndex: Int = 0

    private var tempNewDisplayNumber: String = ""
    private var tempNewDisplayOper: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.clearAll.setOnClickListener { clearAll() }

        binding.divide.setOnClickListener { addOper(it as Button) }
        binding.btnMul.setOnClickListener { addOper(it as Button) }
        binding.btnAdd.setOnClickListener { addOper(it as Button) }
        binding.btnSub.setOnClickListener { addOper(it as Button) }

        binding.number0.setOnClickListener { addNumber(it as Button) }
        binding.number1.setOnClickListener { addNumber(it as Button) }
        binding.number2.setOnClickListener { addNumber(it as Button) }
        binding.number3.setOnClickListener { addNumber(it as Button) }
        binding.number4.setOnClickListener { addNumber(it as Button) }
        binding.number5.setOnClickListener { addNumber(it as Button) }
        binding.number6.setOnClickListener { addNumber(it as Button) }
        binding.number7.setOnClickListener { addNumber(it as Button) }
        binding.number8.setOnClickListener { addNumber(it as Button) }
        binding.number9.setOnClickListener { addNumber(it as Button) }

        binding.btnResult.setOnClickListener { calculate() }
    }

    private fun calculate() {
        var result = 0.0

        val tempMainNumbers = mainNumbers
        val tempMainOpers = mainOpers

        do {
            val num1 = tempMainNumbers.removeFirst()
            val oper = tempMainOpers.removeFirst()

            when (oper) {
                '+' -> {
                    if (tempMainNumbers.isNotEmpty()) {
                        val num2 = tempMainNumbers.removeFirst()
                        result += ((num1 ?: 0) + (num2 ?: 0)).toDouble()
                    } else {
                        result += (num1 ?: 0).toDouble()
                    }
                }
                '-' -> {
                    if (tempMainNumbers.isNotEmpty()) {
                        val num2 = tempMainNumbers.removeFirst()
                        if (result <= 0) {
                            result += ((num1 ?: 0) - (num2 ?: 0)).toDouble()
                        } else {
                            result -= ((num1 ?: 0) - (num2 ?: 0)).toDouble()
                        }
                    } else {
                        result -= (num1 ?: 0).toDouble()
                    }
                }
                'x' -> {
                    if (result == 0.0) { result = 1.0 }
                    if (tempMainNumbers.isNotEmpty()) {
                        val num2 = tempMainNumbers.removeFirst()
                        result *= ((num1 ?: 1) * (num2 ?: 1)).toDouble()
                    } else {
                        result *= (num1 ?: 1).toDouble()
                    }
                }
                '/' -> {
                    if (result == 0.0) { result = 1.0 }
                    if (tempMainNumbers.isNotEmpty()) {
                        val num2 = tempMainNumbers.removeFirst()
                        if (mainNumbers.first() == num1) {
                            result = ((num1 ?: 1) / (num2 ?: 1)).toDouble()
                        } else {
                            result /= ((num1 ?: 1) / (num2 ?: 1)).toDouble()
                        }
                    } else {
                        result /= (num1 ?: 1).toDouble()
                    }

                }
                else -> {
                    result = (num1 ?: 0).toDouble()
                }
            }


        } while (tempMainNumbers.isNotEmpty())

        binding.resultLabelCal.text = result.toString()
    }

    private fun clearAll() {
        if (mainDisplay.isNotEmpty()) {

            mainDisplay = ""

            mainNumbers.clear()
            mainOpers.clear()

            tempNewDisplayNumber = ""
            tempNewDisplayOper = ""

            mainNumbers.add(null)
            mainOpers.add(null)
            currIndex = 0

            binding.resultLabelCal.text = ""
            binding.mainLabelCal.text = mainDisplay.ifEmpty { "0" }
        }
    }

    private fun addNumber(btn: Button) {
        val num : String = btn.text.toString()

        tempNewDisplayOper = ""
        tempNewDisplayNumber += (num)
        mainDisplay += num

        mainNumbers[currIndex] = Integer.parseInt(tempNewDisplayNumber)

        Log.i("INFO", currIndex.toString())
        Log.i("INFO", mainOpers.toString())
        Log.i("INFO", mainNumbers.toString())

        binding.mainLabelCal.text = mainDisplay
    }

    private fun addOper(btn: Button) {
        val sym : String = btn.text.toString()

        tempNewDisplayNumber = ""

        tempNewDisplayOper = sym

        val opers = "+-/x"

        if (mainDisplay.isNotEmpty()) {
            if (!opers.contains(mainDisplay.last())) {
                mainDisplay += sym
            } else {
                mainDisplay = mainDisplay.dropLast(1)
                mainDisplay += sym
            }
        }

        if (mainNumbers[currIndex] != null) {
            mainOpers[currIndex] = tempNewDisplayOper.first()

            currIndex += 1
            mainNumbers.add(null)
            mainOpers.add(null)
        } else {
            val prevIndex = currIndex - 1
            if (prevIndex >= 0) {
                if (mainOpers[prevIndex] != null) {
                    mainOpers[prevIndex] = tempNewDisplayOper.first()
                } else {
                    mainOpers[currIndex] = tempNewDisplayOper.first()
                }
            } else {
                mainOpers[currIndex] = tempNewDisplayOper.first()
            }
        }

        Log.i("INFO", currIndex.toString())
        Log.i("INFO", mainOpers.toString())
        Log.i("INFO", mainNumbers.toString())

        binding.mainLabelCal.text = mainDisplay
    }
}