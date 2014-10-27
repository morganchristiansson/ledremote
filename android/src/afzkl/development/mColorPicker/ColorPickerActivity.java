/*
 * Copyright (C) 2010 Daniel Nilsson
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package afzkl.development.mColorPicker;

import java.io.IOException;
import java.io.PrintStream;
import java.net.Socket;
import afzkl.development.mColorPicker.views.ColorPanelView;
import afzkl.development.mColorPicker.views.ColorPickerView;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class ColorPickerActivity extends Activity implements
		View.OnClickListener, SensorEventListener {

	public final static String INTENT_DATA_INITIAL_COLOR = "color";
	public final static String RESULT_COLOR = "color";

	private ColorPickerView mColorPickerView;
	private ColorPanelView mNewColorPanel;
	private Button mEffectButton, mOrientationButton;

	private Socket socket;
	private PrintStream socketOut;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// To fight color branding.
		getWindow().setFormat(PixelFormat.RGBA_8888);

		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_color_picker);

		Bundle b = getIntent().getExtras();
		int initialColor = 0xff000000;

		if (b != null) {
			initialColor = b.getInt(INTENT_DATA_INITIAL_COLOR);
		}

		try {
			socket = new Socket("192.168.1.71", 2000);
			socketOut = new PrintStream(socket.getOutputStream());
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		setUp(initialColor);
	}

	private void setUp(int color) {
		mColorPickerView = (ColorPickerView) findViewById(R.id.color_picker_view);
		mNewColorPanel = (ColorPanelView) findViewById(R.id.new_color_panel);
		mEffectButton = (Button) findViewById(R.id.effect);
		mOrientationButton = (Button) findViewById(R.id.orientation);

//		((LinearLayout) mNewColorPanel.getParent()).setPadding(Math
//				.round(mColorPickerView.getDrawingOffset()), 0, Math
//				.round(mColorPickerView.getDrawingOffset()), 0);

		mColorPickerView
				.setOnColorChangedListener(new ColorPickerView.OnColorChangedListener() {

					@Override
					public void onColorChanged(int color) {
						mNewColorPanel.setColor(color);
						socketOut.println("RGB "+Color.red(color)+" "+Color.green(color)+" "+Color.blue(color));
					}
				});

		mEffectButton.setOnClickListener(this);
		mOrientationButton.setOnClickListener(this);
		mColorPickerView.setColor(color, true);
		mColorPickerView.setAlphaSliderVisible(false);
		mColorPickerView.setSliderTrackerColor(0xffCECECE);
		mColorPickerView.setBorderColor(0xff7E7E7E);
		mNewColorPanel.setBorderColor(mColorPickerView.getBorderColor());

	}

	private SensorManager mSensorManager;
	private Sensor mSensor;
	
	@Override
	public void onClick(View v) {
		if(v.getId() == R.id.effect) {
			socketOut.println("EFFECT");
		} else if(v.getId() == R.id.orientation) {
			mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
			mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR);
			mSensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_UI);

		}
	}

	@Override
	public void onAccuracyChanged(Sensor arg0, int arg1) {}

	@Override
	public void onSensorChanged(SensorEvent event) {
	    switch(event.sensor.getType()){
		    case Sensor.TYPE_ROTATION_VECTOR:
		        onOrientChanged(event);
		        break;
	    }
	}

	private void onOrientChanged(SensorEvent event) {
	    float posX,posY,posZ;
	    posX = event.values[0];
	    posY = event.values[1];
	    posZ = event.values[2];
	    
	    double multiplier = (posX + 0.5);

	    System.out.println("X="+posX+" Y="+posY+" Z="+posZ+" multiplier "+multiplier);
	    int color = (int) (255.0 * multiplier);
	    socketOut.println("RGB "+color+" "+color+" "+color);
	    //((TextView)findViewById(R.id.azimuth)).setText("Axe x "+azimuth);
	    //((TextView)findViewById(R.id.pitch)).setText("Axe y "+pitch);
	    //((TextView)findViewById(R.id.roll)).setText("Axe z "+roll);
	}
}
