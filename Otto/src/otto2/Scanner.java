/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package otto2;

/**
 *
 * @author 00918055
 */
public class Scanner extends Thread implements Runnable {
    public int fromPort;
    public int toPort;
    public String host;
    private Tentacle _t[];
    private Thread _th[];
    javax.swing.JProgressBar bar;

    public Scanner() {
        host = new String();
        fromPort = 1;
        toPort = 65535;
    }

    public Scanner(String host, int fromPort, int toPort, javax.swing.JProgressBar bar) {
        System.out.println("Creating scanner for " + host + " port " +
                fromPort + ".." + toPort);
        this.host = host;
        this.fromPort = fromPort;
        this.toPort = toPort;
        this.bar = bar;
    }

    @Override
    public void run() {
        // Making room
        _t = new Tentacle[toPort - fromPort];
        _th = new Thread[toPort - fromPort];

        int barValue;

        try {
            for (int i = 0; i < toPort - fromPort; i++) {
                //System.out.println("Adding tentacle for port " + (i + fromPort));
                _t[i] = new Tentacle(host, i + fromPort);
                _th[i] = new Thread(_t[i]);
                _th[i].start();

                barValue = i * 50 / (toPort - fromPort);
                bar.setValue(barValue);
            }
            System.out.println("JOIN IN PROGRESS");

            for (int i = 0; i < toPort - fromPort; i++) {
                //System.out.println("Joining thread " + i);
                if (_t[i].isOpen()) {
                    System.out.println("Port " + (i+fromPort) + " open");
                }
                _th[i].join();

                barValue = i * 50 / (toPort - fromPort) + 51;
                //System.out.println("Join value " + barValue);
                bar.setValue(barValue);
            }
        } catch(Exception e) {
            System.out.println("Exception: " + e.toString());
        }
        System.out.println("Scan finished.");
    }
}
