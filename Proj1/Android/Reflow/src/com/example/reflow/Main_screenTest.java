package com.example.reflow;

import static org.junit.Assert.*;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.junit.Test;

import java.io.IOException;

public class Main_screenTest {
	@Test
	public void regex() {
		Double index = 0.0;
		Double expect =25.5117;
		String data = "Target: 025°C , Actual: 025.5117°C , Room: 024.3437°C";
		Pattern dataPattern = Pattern
				.compile("Target: (\\d\\d\\d)°C , Actual: (\\d\\d\\d.\\d\\d\\d\\d)°C , Room: (\\d\\d\\d.\\d\\d\\d\\d)°C");
		Matcher dataMatch = dataPattern.matcher(data);
		if (dataMatch.find()) {
			try {
				index = Double.parseDouble(dataMatch.group(2));
				ReflowOven.setTempa((int) ((index * (0.0049)) / (.0164)) + 24);
			} catch (NumberFormatException e) {
				fail("caught number format exception");
			}
		}else
			fail("could not find match");
		assertEquals(expect, index, 0);
		
	}
}
